#!/usr/bin/env python3
"""
live-wallpaper.py — single-script pipeline:
  - pick video (arg or interactive)
  - kill old mpvpaper
  - start mpvpaper with hwdec=vaapi
  - extract random frame with ffmpeg
  - run 'wal' (pywal) on extracted frame to preserve existing pipeline
  - extract palette via colorthief -> write ~/.cache/colorthief/palette.json
  - reload eww and run pywal-colorset.sh (if present)
  - notify user
"""
from pathlib import Path
import subprocess, sys, random, json, shutil, os

# config
WALLPAPER_DIR = Path.home() / "Videos" / "Wallpapers" / "Live"
MPVPYWAL_DIR = Path.home() / ".local" / "bin" / "mpvpywal"
FRAME_PATH = MPVPYWAL_DIR / "mpvshot.jpg"
PALETTE_JSON = Path.home() / ".cache" / "colorthief" / "palette.json"
COLORSET_SCRIPT = Path.home() / ".local" / "bin" / "pywal-colorset.sh"
MONITOR = "HDMI-A-1"   # change if your monitor name differs

MPVPYWAL_DIR.mkdir(parents=True, exist_ok=True)
PALETTE_JSON.parent.mkdir(parents=True, exist_ok=True)

def pick_video():
    if len(sys.argv) > 1 and Path(sys.argv[1]).is_file():
        return Path(sys.argv[1])
    videos = sorted(list(WALLPAPER_DIR.glob("*.mp4")) + list(WALLPAPER_DIR.glob("*.webm")))
    if not videos:
        print(f"No videos found in {WALLPAPER_DIR}")
        sys.exit(1)
    print("Choose Your Live Wallpaper:")
    for i, v in enumerate(videos):
        print(f"  [{i}] {v.name}")
    choice = input("Enter number: ").strip()
    if not choice.isdigit() or int(choice) not in range(len(videos)):
        print("Invalid choice.")
        sys.exit(1)
    return videos[int(choice)]

def kill_existing():
    subprocess.run(["pkill", "-x", "mpvpaper"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def start_mpvpaper(video: Path):
    # use vaapi explicitly for AMD to avoid CUDA/VDPAU probing noise
    args = [
        "mpvpaper",
        "-o", f"no-audio --loop --hwdec=vaapi --screenshot-template={FRAME_PATH}",
        MONITOR, str(video)
    ]
    # start detached
    subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def extract_frame(video: Path) -> bool:
    # try ffprobe for duration, fallback to 30s
    try:
        out = subprocess.check_output([
            "ffprobe", "-v", "error",
            "-show_entries", "format=duration",
            "-of", "default=noprint_wrappers=1:nokey=1",
            str(video)
        ], stderr=subprocess.DEVNULL).decode().strip()
        duration = float(out) if out else 30.0
    except Exception:
        duration = 30.0
    t = random.randint(0, max(1, int(duration) - 1))
    FRAME_PATH.unlink(missing_ok=True)
    rc = subprocess.run([
        "ffmpeg", "-y", "-ss", str(t), "-i", str(video),
        "-frames:v", "1", str(FRAME_PATH)
    ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return rc.returncode == 0 and FRAME_PATH.exists()

def run_pywal(frame: Path):
    if shutil.which("wal"):
        subprocess.run(["wal", "-i", str(frame), "--vte", "-a", "100"], check=False)
    else:
        print("pywal not found; skipping wal step (your configs may still expect pywal output).")

def generate_palette(frame: Path):
    try:
        from colorthief import ColorThief
    except Exception as e:
        print("colorthief not available:", e)
        return []
    try:
        ct = ColorThief(str(frame))
        palette = ct.get_palette(color_count=6, quality=1)
        hex_palette = ["#{:02x}{:02x}{:02x}".format(*c) for c in palette]
        data = {"palette": hex_palette, "source": str(frame)}
        PALETTE_JSON.write_text(json.dumps(data, indent=2))
        return hex_palette
    except Exception as e:
        print("Color extraction failed:", e)
        return []

def apply_theme_and_reload():
    # try eww reload
    if shutil.which("eww"):
        subprocess.run(["eww", "reload"], check=False)
    # run colorset bridge script if present
    if COLORSET_SCRIPT.exists() and os.access(str(COLORSET_SCRIPT), os.X_OK):
        subprocess.run([str(COLORSET_SCRIPT)], check=False)

def notify(msg: str):
    if shutil.which("notify-send"):
        subprocess.run(["notify-send", "LiveWal", msg], check=False)

def main():
    video = pick_video()
    print("Selected:", video.name)
    kill_existing()
    start_mpvpaper(video)
    if extract_frame(video):
        print("Frame extracted:", FRAME_PATH)
        run_pywal(FRAME_PATH)                       # keeps old pipeline working
        pal = generate_palette(FRAME_PATH)         # also produce palette.json
        if pal:
            print("Palette:", pal)
        apply_theme_and_reload()
        notify(f"Wallpaper set: {video.name}")
    else:
        print("Frame extraction failed")

if __name__ == "__main__":
    main()
