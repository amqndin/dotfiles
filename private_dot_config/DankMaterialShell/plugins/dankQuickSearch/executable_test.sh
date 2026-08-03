#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

pass() { ((PASS++)); echo "  PASS: $1"; }
fail() { ((FAIL++)); echo "  FAIL: $1 — $2"; }

assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    if [ "$expected" = "$actual" ]; then
        pass "$desc"
    else
        fail "$desc" "expected '$expected', got '$actual'"
    fi
}

# ── plugin.json validation ──────────────────────────────────────────

echo "plugin.json"
python3 -c "import json; d=json.load(open('plugin.json')); assert d['id']=='dankQuickSearch'; assert d['name']=='Quick Search'" \
    && pass "valid JSON with correct id and name" \
    || fail "plugin.json" "invalid or wrong id/name"

python3 -c "
import json
d = json.load(open('plugin.json'))
required = ['id','name','description','version','author','type','capabilities','component','settings','trigger','requires_dms','requires','permissions']
missing = [f for f in required if f not in d]
assert not missing, f'missing fields: {missing}'
" && pass "all required fields present" \
  || fail "plugin.json" "missing required fields"

# ── version format ──────────────────────────────────────────────────

echo "version"
VERSION=$(jq -r .version plugin.json)
if echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    pass "semver format ($VERSION)"
else
    fail "version" "'$VERSION' is not valid semver"
fi

# ── QML file references ─────────────────────────────────────────────

echo "file references"
COMPONENT=$(python3 -c "import json; print(json.load(open('plugin.json'))['component'])")
SETTINGS=$(python3 -c "import json; print(json.load(open('plugin.json'))['settings'])")
# Strip leading ./
COMPONENT="${COMPONENT#./}"
SETTINGS="${SETTINGS#./}"

if [ -f "$COMPONENT" ]; then
    pass "component file exists ($COMPONENT)"
else
    fail "component" "$COMPONENT not found"
fi

if [ -f "$SETTINGS" ]; then
    pass "settings file exists ($SETTINGS)"
else
    fail "settings" "$SETTINGS not found"
fi

# ── pluginId consistency ─────────────────────────────────────────────

echo "pluginId consistency"
EXPECTED_ID=$(python3 -c "import json; print(json.load(open('plugin.json'))['id'])")

QML_ID=$(grep -oP 'pluginId:\s*"\K[^"]+' "$COMPONENT")
assert_eq "main QML pluginId matches plugin.json" "$EXPECTED_ID" "$QML_ID"

SETTINGS_ID=$(grep -oP 'pluginId:\s*"\K[^"]+' "$SETTINGS")
assert_eq "settings QML pluginId matches plugin.json" "$EXPECTED_ID" "$SETTINGS_ID"

# ── engine definitions ───────────────────────────────────────────────

echo "engine definitions"

# Each engine needs id, name, icon, prefix, url
ENGINE_COUNT=$(grep -c '{ id:' "$COMPONENT" || true)
assert_eq "4 search engines defined" "4" "$ENGINE_COUNT"

# No Wikipedia engine (was removed)
if grep -q 'wikipedia' "$COMPONENT"; then
    fail "wikipedia removed" "still references wikipedia"
else
    pass "wikipedia removed"
fi

# Required engines present
for engine in duckduckgo google github youtube; do
    if grep -q "\"$engine\"" "$COMPONENT"; then
        pass "$engine engine present"
    else
        fail "$engine" "engine not found in QML"
    fi
done

# ── URL construction ─────────────────────────────────────────────────

echo "URL construction"

# Verify search URLs end with query parameter
for url_part in "duckduckgo.com/?q=" "google.com/search?q=" "github.com/search?q=" "youtube.com/results?search_query="; do
    if grep -q "$url_part" "$COMPONENT"; then
        pass "valid URL pattern: $url_part"
    else
        fail "URL" "missing pattern $url_part"
    fi
done

# ── summary ──────────────────────────────────────────────────────────

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
