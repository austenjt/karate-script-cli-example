#!/bin/bash

# Define variables
KARATE_VERSION="1.4.1"
KARATE_JAR_URL="https://github.com/karatelabs/karate/releases/download/v${KARATE_VERSION}/karate-${KARATE_VERSION}.jar"
DEST_DIR="$(pwd)" # Saves the file in the current directory
LOCAL_FILE="${DEST_DIR}/karate-${KARATE_VERSION}.jar"
LOG_FILE="${DEST_DIR}/karate-test-output.log"
REPORT_FILE="${DEST_DIR}/target/karate-reports/karate-summary.html"

# Check if the Karate JAR is already downloaded
if [ -f "${LOCAL_FILE}" ]; then
  echo "Karate standalone JAR version ${KARATE_VERSION} is already downloaded: ${LOCAL_FILE}"
else
  # Download the JAR if it doesn't exist
  echo "Downloading Karate standalone JAR version ${KARATE_VERSION}..."
  curl -L -o "${LOCAL_FILE}" "${KARATE_JAR_URL}"

  # Verify download size
  FILE_SIZE=$(stat -c%s "${LOCAL_FILE}")
  if [ "$FILE_SIZE" -lt 1000000 ]; then  # Expecting a file size in MB
    echo "Error: Downloaded file is too small, indicating an issue. File size: ${FILE_SIZE} bytes."
    rm -f "${LOCAL_FILE}"  # Remove the incorrect file
    exit 1
  else
    echo "Download completed successfully: ${LOCAL_FILE}"
  fi
fi

# Set CLASSPATH
export CLASSPATH="${LOCAL_FILE}:${CLASSPATH}"

# Get current directory path
CDIR_TMP="$(pwd)"

# Run Karate test and output to both console and log file
java -jar "${LOCAL_FILE}" "${CDIR_TMP}/script.feature" 2>&1 | tee "${LOG_FILE}"

# Confirm the log file location
if [ -f "${LOG_FILE}" ]; then
  echo "Karate log report generated in: ${LOG_FILE}"
else
  echo "Error: Failed to generate Karate log report."
fi

# Display the report location
if [ -f "${REPORT_FILE}" ]; then
  echo "Karate HTML report generated at: ${REPORT_FILE}"
else
  echo "Error: Karate HTML report not found at expected location: ${REPORT_FILE}"
fi

