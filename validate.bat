@echo off
echo Starting port-forwarding for all StreamingApp services...
echo Please wait 5 seconds before opening your browser.

start /B kubectl port-forward svc/frontend 3000:80 >nul 2>&1
start /B kubectl port-forward svc/auth 3001:3001 >nul 2>&1
start /B kubectl port-forward svc/streaming 3002:3002 >nul 2>&1
start /B kubectl port-forward svc/admin 3003:3003 >nul 2>&1
start /B kubectl port-forward svc/chat 3004:3004 >nul 2>&1

echo.
echo All services are now accessible locally!
echo Frontend: http://localhost:3000
echo Auth API: http://localhost:3001
echo Streaming API: http://localhost:3002
echo Admin API: http://localhost:3003
echo Chat API: http://localhost:3004
echo.
echo Press any key to stop all port-forwarding...
pause >nul

taskkill /IM kubectl.exe /F >nul 2>&1
echo Port-forwarding stopped.
