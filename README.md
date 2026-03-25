# PiKVM Web UI Customization

Customized PiKVM web UI with white-labeling and simplified interface.

## What's Changed (vs original PiKVM web UI)

- **De-branded**: all "PiKVM" references replaced with "xxx"
- **Simplified index page**: logo, server info, copyright, help text all hidden; only app entry buttons remain
- **KVM path renamed**: `/kvm/` → `/xxx/`
- **Password protection**: non-KVM apps (e.g. Terminal) prompt for password before access
- **Browser tab title**: "PiKVM Session" → "xxx Session" (dynamic hostname still works)
- **Login page**: logo hidden
- **System menu preserved**: top-right System dropdown (4 status LEDs + Runtime settings & tools) remains visible; other menus (Shortcuts, Text, Macro, Drive, ATX) hidden

## Branch Structure

- `master` — original PiKVM web UI source (untouched baseline)
- `main` — customized version

## Deploy to PiKVM

### First Time

```bash
ssh root@<pikvm-ip>
rw
cd /usr/share/kvmd/
mv web web-bak
git clone https://github.com/vewe-richard/pi-kvm-customize.git web
cd web
git checkout main
ro
```

### Install Pacman Hook (one-time)

This ensures the custom UI is automatically restored after `pikvm-update`:

```bash
rw
mkdir -p /etc/pacman.d/hooks
cp /usr/share/kvmd/web/99-kvmd-web-custom.hook /etc/pacman.d/hooks/
ro
```

### After kvmd Update (manual, if hook not installed)

```bash
ssh root@<pikvm-ip>
rw
cd /usr/share/kvmd/
rm -rf web
git clone https://github.com/vewe-richard/pi-kvm-customize.git web
cd web
git checkout main
ro
```

### Or Run the Deploy Script

```bash
ssh root@<pikvm-ip>
/usr/share/kvmd/web/deploy.sh
```

## Local Preview

For local UI preview without a real PiKVM backend:

```bash
cd pi-kvm-customize
python3 mock_server.py
```

- Index page: http://localhost:8080/
- KVM session page: http://localhost:8080/xxx/

## Files Modified

| File | Change |
|------|--------|
| `index.html` | De-branded, hidden UI elements, added password prompt |
| `login/index.html` | Hidden logo |
| `share/js/index/main.js` | KVM path → xxx, password-protected app links |
| `share/js/kvm/info.js` | Browser tab title: xxx Session |
| `xxx/index.html` | KVM session page (copied from kvm/), System menu restored |
| `deploy.sh` | Auto-deploy script |
| `99-kvmd-web-custom.hook` | Pacman hook for update persistence |
