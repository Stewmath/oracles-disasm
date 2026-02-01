#!/usr/bin/env python3
"""
Test script to verify bit-perfect compression.
Decompresses and recompresses all .cmp files and verifies they match the original.
"""

import sys
import os
import glob
import tempfile
import subprocess

# Add the compression module to the path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../compression'))

from gfx.decompress import decompress

def test_file(cmp_path, compressor_script):
    """
    Test a single .cmp file by decompressing and recompressing it.
    Returns True if the round-trip matches the original, False otherwise.
    """
    # Read the compressed file
    with open(cmp_path, 'rb') as f:
        original_data = f.read()
    
    # Get the original compression mode from the header
    if len(original_data) < 3:
        print(f"  ✗ File too small")
        return False
    
    original_mode = original_data[0]
    
    # Decompress it
    try:
        decompressed_data = decompress(original_data)
    except Exception as e:
        print(f"  ✗ Failed to decompress: {e}")
        return False
    
    # Create temporary files for the decompressed and recompressed data
    with tempfile.NamedTemporaryFile(mode='wb', delete=False, suffix='.bin') as temp_in:
        temp_in.write(decompressed_data)
        temp_in_path = temp_in.name
    
    with tempfile.NamedTemporaryFile(mode='wb', delete=False, suffix='.cmp') as temp_out:
        temp_out_path = temp_out.name
    
    try:
        # Recompress using compressGfx.py with --bit-perfect flag and the original mode
        result = subprocess.run(
            ['python3', compressor_script, '--bit-perfect', '--mode', str(original_mode), 
             temp_in_path, temp_out_path],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            print(f"  ✗ Compression failed: {result.stderr}")
            return False
        
        # Read the recompressed data
        with open(temp_out_path, 'rb') as f:
            recompressed_data = f.read()
        
        # Compare
        if original_data == recompressed_data:
            return True
        else:
            # Show the differences
            print(f"  ✗ Mismatch! Original size: {len(original_data)}, Recompressed size: {len(recompressed_data)}")
            
            # Show byte-by-byte diff for first few bytes
            min_len = min(len(original_data), len(recompressed_data))
            for i in range(min(min_len, 20)):
                if original_data[i] != recompressed_data[i]:
                    print(f"    Byte {i}: original={original_data[i]:02x}, recompressed={recompressed_data[i]:02x}")
            
            if len(original_data) != len(recompressed_data):
                print(f"    Length mismatch at byte {min_len}")
            
            return False
    finally:
        # Clean up temporary files
        if os.path.exists(temp_in_path):
            os.unlink(temp_in_path)
        if os.path.exists(temp_out_path):
            os.unlink(temp_out_path)

def main():
    # Find the compressor script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    compressor_script = os.path.join(script_dir, 'build', 'compressGfx.py')
    
    if not os.path.exists(compressor_script):
        print(f"Error: Compressor script not found at {compressor_script}")
        sys.exit(1)
    
    # Find all .cmp files in precompressed/gfx_compressible/ages/
    cmp_dir = os.path.join(script_dir, '..', 'precompressed', 'gfx_compressible', 'ages')
    cmp_files = sorted(glob.glob(os.path.join(cmp_dir, '*.cmp')))
    
    if not cmp_files:
        print(f"Error: No .cmp files found in {cmp_dir}")
        sys.exit(1)
    
    # Known corrupted files to skip
    skip_files = {
        'spr_seasonfairy_ambi_jp.cmp'  # Corrupted file that doesn't decompress properly
    }
    
    print(f"Testing {len(cmp_files)} files from {cmp_dir}")
    if skip_files:
        print(f"Skipping {len(skip_files)} known corrupted file(s): {', '.join(skip_files)}")
    print()
    
    passed = 0
    failed = 0
    skipped = 0
    failed_files = []
    
    for cmp_path in cmp_files:
        filename = os.path.basename(cmp_path)
        
        if filename in skip_files:
            print(f"Skipping {filename} (known corrupted)")
            skipped += 1
            continue
        
        print(f"Testing {filename}...", end=' ')
        
        if test_file(cmp_path, compressor_script):
            print("✓")
            passed += 1
        else:
            failed += 1
            failed_files.append(filename)
    
    print()
    print(f"Results: {passed} passed, {failed} failed, {skipped} skipped")
    
    if failed > 0:
        print("\nFailed files:")
        for filename in failed_files:
            print(f"  - {filename}")
        sys.exit(1)
    else:
        print("\n✓ All files passed bit-perfect round-trip test!")
        sys.exit(0)

if __name__ == '__main__':
    main()
