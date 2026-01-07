#!/bin/bash
# Deep & Safe RAM Cleaner

# 1. VISUALIZE BEFORE
echo "======================================================"
echo "MEMORY STATUS (BEFORE)"
echo "------------------------------------------------------"
free -h
echo "======================================================"

# 2. THE CLEANING PROCESS
echo "Starting Deep Clean..."

# Step A: Sync Data (Safety First)
# Writes any data waiting in RAM to the hard drive so we don't lose it.
echo "[1/3] Syncing filesystem buffers..."
sync

# Step B: Drop Caches (The Standard Clean)
# Clears PageCache (files), Dentries (folders), and Inodes (file structures).
echo "[2/3] Dropping filesystem caches..."
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

# Step C: Compact Memory (The Advanced Fix)
# This defragments the remaining RAM. It doesn't "kill" apps, 
# but it organizes the data they use more efficiently, potentially freeing blocks.
echo "[3/3] Compacting memory to reduce fragmentation..."
echo 1 | sudo tee /proc/sys/vm/compact_memory > /dev/null

echo "------------------------------------------------------"
echo "Clean Complete."
sleep 1

# 3. THE REALITY CHECK (Ghost Process Detector)
# If RAM is still high, this shows you WHY. 
# It lists the top 5 processes actively holding RAM right now.
echo ""
echo "TOP 5 APPS STILL HOLDING RAM (Active Memory):"
echo "------------------------------------------------------"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo "------------------------------------------------------"

# 4. FINAL STATUS
echo ""
echo "NEW MEMORY USAGE:"
free -h
echo "======================================================"


