import requests
import zipfile
import io
import os

# The direct URL to the ZIP file containing the data
zip_file_url = "https://openpowerlifting.gitlab.io/opl-csv/files/openpowerlifting-latest.zip"

# The final location and consistent filename for the output CSV
output_folder = r"C:\SQL_Data"
final_csv_filename = "openpowerlifting-latest.csv"
final_csv_path = os.path.join(output_folder, final_csv_filename)

print(f"Starting download of ZIP file from {zip_file_url}...")

try:
    # Step 1: Download the ZIP file into memory
    response = requests.get(zip_file_url, timeout=180) # Increased timeout for large file
    response.raise_for_status()
    print("SUCCESS: ZIP file downloaded.")

    # Step 2: Open the ZIP file from memory
    with zipfile.ZipFile(io.BytesIO(response.content)) as thezip:
        
        # Step 3: Find the CSV file inside the ZIP (without knowing its exact name)
        csv_filename_in_zip = None
        for filename in thezip.namelist():
            if filename.endswith('.csv'):
                csv_filename_in_zip = filename
                break # Found the CSV, no need to look further

        if csv_filename_in_zip:
            print(f"SUCCESS: Found CSV file '{csv_filename_in_zip}' inside the ZIP archive.")
            
            # Step 4: Extract the CSV file's content
            with thezip.open(csv_filename_in_zip) as thefile:
                # Step 5: Save the extracted content to our consistent final path
                with open(final_csv_path, 'wb') as f:
                    f.write(thefile.read())
                print(f"SUCCESS: CSV data has been extracted and saved to {final_csv_path}")
        else:
            print("ERROR: Could not find any .csv file inside the downloaded ZIP file.")

except requests.exceptions.RequestException as e:
    print(f"ERROR: A download error occurred: {e}")
except zipfile.BadZipFile:
    print("ERROR: The downloaded file was not a valid ZIP file.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
