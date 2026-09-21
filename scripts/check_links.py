"""Internal Markdown link check: every relative link and image in the repository's Markdown must exist.
External links are the advisory lychee job's business."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LINK = re.compile(r"!?\[[^\]]*\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")


def check() -> int:
    refs = 0
    broken: list[str] = []
    for md in sorted(ROOT.rglob("*.md")):
        if any(part in {"node_modules", ".git"} for part in md.parts):
            continue
        for target in LINK.findall(md.read_text(encoding="utf-8")):
            if re.match(r"^(https?:|mailto:|#)", target):
                continue
            refs += 1
            path = target.split("#")[0]
            resolved = (ROOT / path.lstrip("/")) if path.startswith("/") else (md.parent / path)
            if not resolved.exists():
                broken.append(f"{md.relative_to(ROOT)}: {target}")
    print(f"{refs} internal references, {len(broken)} broken")
    for b in broken:
        print(" ", b)
    return 1 if broken else 0


if __name__ == "__main__":
    sys.exit(check())
