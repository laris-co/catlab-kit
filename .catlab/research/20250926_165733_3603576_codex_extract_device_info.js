#!/usr/bin/env node

const fs = require('fs').promises;
const path = require('path');
const process = require('process');

const jobFilePath = path.resolve(__dirname, '../../job.json');

async function readJobFile(filePath) {
  try {
    console.log(`[INFO] Reading job file at ${filePath}`);
    return await fs.readFile(filePath, 'utf8');
  } catch (error) {
    if (error?.code === 'ENOENT') {
      throw new Error(`Job file not found at ${filePath}`);
    }
    throw new Error(`Unable to read job file: ${error.message}`);
  }
}

async function parseJob(content) {
  try {
    return JSON.parse(content);
  } catch (error) {
    throw new Error(`Invalid JSON in job file: ${error.message}`);
  }
}

function extractDeviceInfo(jobData) {
  if (!Array.isArray(jobData)) {
    throw new Error('Unexpected job format: expected an array of devices');
  }

  // Collect devices that have both a usable name and serial number.
  const devices = jobData.reduce((accumulator, entry, index) => {
    const name = typeof entry?.name === 'string' ? entry.name.trim() : '';
    const serial = typeof entry?.serialNumber === 'string' ? entry.serialNumber.trim() : '';

    if (!name) {
      console.warn(`[WARN] Skipping device at index ${index}: missing or invalid name.`);
      return accumulator;
    }

    if (!serial) {
      console.warn(`[WARN] Skipping device '${name}': missing or invalid serial number.`);
      return accumulator;
    }

    accumulator.push({ name, serial });
    return accumulator;
  }, []);

  if (devices.length === 0) {
    console.log('[WARN] No devices with valid name and serial number found.');
  }

  return devices;
}

async function main() {
  try {
    const rawJob = await readJobFile(jobFilePath);
    const jobData = await parseJob(rawJob);
    const devices = extractDeviceInfo(jobData);
    const collator = new Intl.Collator('en', { numeric: true, sensitivity: 'base' });
    devices.sort((a, b) => collator.compare(a.name, b.name));

    devices.forEach(({ name, serial }, index) => {
      console.log(`[DEVICE ${index + 1}] Name: ${name}`);
      console.log(`[DEVICE ${index + 1}] Serial Number: ${serial}`);
    });
  } catch (error) {
    console.error(`[ERROR] ${error.message}`);
    if (error?.stack) {
      console.debug(error.stack);
    }
    process.exitCode = 1;
  }
}

main();
