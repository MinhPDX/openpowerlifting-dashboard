:: refresh_data.bat
echo "Step 1: Downloading latest CSV..."
python "C:\SQL_Data\download_latest_data.py"

echo "Step 2: Running SQL database update..."
sqlcmd -S localhost -d OpenPowerlifting -Q "EXEC dbo.sp_RefreshMeetResults"

echo "Automation complete."
