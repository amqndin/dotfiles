#!/usr/bin/env python3
"""Pick a workspace-switch *feel*, get the exact niri spring values.

niri damped springs only care about two numbers:
  damping-ratio  = bounce. 1.0 = none, lower = bouncier.
  stiffness      = speed.  Higher = lands sooner (and makes far jumps
                   faster/blurrier, since duration is fixed).
epsilon just decides when niri officially stops animating the last
sub-pixel creep. Leave it unless you have a reason.

Give it the feel you want, get the numbers:

    python3 spring-calc.py --land 100 --bounce 8
    python3 spring-calc.py                  # ask me instead

Order of operations:
    1. bounce (px)        -> damping-ratio
    2. land time (ms)     -> stiffness
    3. done time (ms)     -> epsilon (optional, otherwise default)

"land"  = the moment the target workspace crosses into place.
"done"  = the moment niri cuts the animation (usually ~1px left).
"""

import argparse
import math

DEFAULT_HEIGHT = 900  # px: your workspace height (bounce px are relative to it)
DEFAULT_EPSILON = 0.0001


def zeta_from_overshoot(frac: float) -> float:
    """Overshoot fraction -> damping-ratio (exact, for underdamped springs)."""
    if frac <= 0.0:
        return 1.0  # no overshoot = critically damped
    c = math.log(1.0 / frac) / math.pi          # c = zeta / sqrt(1 - zeta^2)
    return c / math.sqrt(1.0 + c * c)


def find_u(target: float) -> float:
    """Solve (1+u)*e^-u == target (critically damped distance curve)."""
    lo, hi = 0.0, 40.0
    for _ in range(100):
        mid = (lo + hi) / 2.0
        if (1.0 + mid) * math.exp(-mid) > target:
            lo = mid
        else:
            hi = mid
    return (lo + hi) / 2.0


def compute(land_ms, bounce_px, height, epsilon, done_ms=None):
    if land_ms <= 0 or height <= 0 or bounce_px < 0:
        raise ValueError("land and height must be > 0, bounce >= 0")
    if bounce_px >= height * 0.15:
        raise ValueError("that's more than 15% overshoot — it will look broken")

    t_land = land_ms / 1000.0
    zeta = zeta_from_overshoot(bounce_px / height)
    amp = 1.0 / math.sqrt(1.0 - zeta * zeta) if zeta < 0.999 else 1.0

    if zeta >= 0.999:
        # Critically damped: never crosses, so "land" means "within 1px".
        beta = find_u(1.0 / height) / t_land
        omega0 = beta
        land_note = f"within 1px at {land_ms} ms (critically damped, no crossing)"
    else:
        omega0 = (math.pi - math.acos(zeta)) / (t_land * math.sqrt(1.0 - zeta * zeta))
        beta = zeta * omega0
        land_note = f"crosses the target at {land_ms} ms"

    stiffness = omega0 * omega0

    if done_ms:
        epsilon = math.exp(-beta * done_ms / 1000.0)

    if epsilon <= 0:
        raise ValueError("epsilon went <= 0 — impossible to be 'done' that fast")

    # --- what that combination looks like ---
    total = math.log(1.0 / epsilon) / beta          # niri's official duration
    if zeta >= 0.999:
        within_1pct = find_u(0.01) / beta
        within_1px = find_u(1.0 / height) / beta
        leftover = (1.0 + math.log(1.0 / epsilon)) * epsilon * height
    else:
        within_1pct = math.log(amp / 0.01) / beta
        within_1px = math.log(amp * height) / beta
        leftover = amp * epsilon * height

    return {
        "zeta": zeta,
        "stiffness": round(stiffness),
        "epsilon": epsilon,
        "overshoot_pct": bounce_px / height * 100.0,
        "bounce_px": bounce_px,
        "land_ms": land_ms,
        "land_note": land_note,
        "within_1pct_ms": within_1pct * 1000,
        "within_1px_ms": within_1px * 1000,
        "total_ms": total * 1000,
        "leftover_px": leftover,
    }


def show(r):
    line = (
        f"spring damping-ratio={r['zeta']:.3f} stiffness={r['stiffness']} "
        f"epsilon={r['epsilon']:g}"
    )
    if r["zeta"] >= 0.999:
        line = line.replace("damping-ratio=1.000", "damping-ratio=1.0")

    print("--- feel you asked for ---")
    print(f"  lands      {r['land_ms']:.0f} ms   <- {r['land_note']}")
    print(f"  bounces    {r['bounce_px']:.2f} px ({r['overshoot_pct']:.2f}%) "
          f"per workspace crossed")
    print()
    print("--- spring values ---")
    print(f"  damping-ratio = {line.split('damping-ratio=')[1].split()[0]}")
    print(f"  stiffness     = {r['stiffness']}")
    print(f"  epsilon       = {r['epsilon']:g}")
    print()
    print("--- what that actually looks like ---")
    print(f"  target crosses in  {r['land_ms']:.0f} ms")
    print(f"  within ~1% (9px)   {r['within_1pct_ms']:.0f} ms")
    print(f"  last visible px    {r['within_1px_ms']:.0f} ms")
    print(f"  niri official end  {r['total_ms']:.0f} ms "
          f"(~{r['leftover_px']:.1f} px left)")
    print()
    print("paste this into layout.kdl:")
    print(f"  workspace-switch {{\n      {line}\n  }}")

    if r["zeta"] < 0.7:
        print("\nnote: damping below ~0.7 — expect a serious, wobbly bounce.")
    if r["zeta"] >= 0.999:
        print("\nnote: no bounce -> critically damped (zeta = 1.0). It creeps in")
        print("      instead of crossing, so 'land' here means 'within 1px'.")
    if r["leftover_px"] > 1.0:
        print(f"\nnote: leftover at end is {r['leftover_px']:.1f}px. If the switch")
        print("      visibly 'pops' at the end, lower epsilon to about half of it.")
    if r["stiffness"] > 2500:
        print("\nnote: that stiffness is very high. Multi-workspace jumps will be")
        print("      fast and blurry (short duration x many workspaces).")


def interactive():
    print("niri workspace-switch spring calculator")
    print("(just press Enter for the defaults)\n")
    land = input("  target lands after (ms)      [100] > ") or "100"
    bounce = input("  bounce past the target (px)  [8]   > ") or "8"
    height = input("  your workspace height (px)   [900] > ") or "900"
    eps = input("  epsilon (0.0001 is fine)     [0.0001] > ") or "0.0001"
    done = input("  done by (ms, optional)       [] > ") or None
    return float(land), float(bounce), float(height), float(eps), (
        float(done) if done else None
    )


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--land", type=float, default=None,
                    help="when you want the target on screen, ms")
    ap.add_argument("--bounce", type=float, default=None,
                    help="how far you want it to sail past, px")
    ap.add_argument("--height", type=float, default=DEFAULT_HEIGHT,
                    help=f"workspace height in px (default {DEFAULT_HEIGHT})")
    ap.add_argument("--epsilon", type=float, default=DEFAULT_EPSILON,
                    help=f"spring epsilon (default {DEFAULT_EPSILON})")
    ap.add_argument("--done", type=float, default=None,
                    help="optional: official end time, ms (derives epsilon)")
    a = ap.parse_args()

    if a.land is None or a.bounce is None:
        land, bounce, height, eps, done = interactive()
    else:
        land, bounce, height, eps, done = a.land, a.bounce, a.height, a.epsilon, a.done

    try:
        show(compute(land, bounce, height, eps, done))
    except ValueError as e:
        print(f"no can do: {e}")


if __name__ == "__main__":
    main()