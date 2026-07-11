HEX NEXUS ONE-CLICK HOST LAUNCHER 0.3

Purpose
Double-click Start Hex Nexus Host.bat to start the private server, wait until it
is ready, and then open the Hex Nexus client.

Installation for the current prototype
Extract the contents of this package directly into:
C:\Users\MyPc\ArcaneTable\Prototype-0.2

The launcher expects the Client folder in Prototype-0.2. During this transition
it can use the validated Server folder in Prototype-0.1 automatically. A later
installer will place the runtime and both components into one self-contained app.

Safety behavior
- Does not install software or change Windows settings.
- Does not change firewall, router, Java, or network configuration.
- Does not start a second server if port 17171 is already active.
- Waits for the server before opening the client.
- Writes a diagnostic log to Launcher-Logs\host-launcher.log.
