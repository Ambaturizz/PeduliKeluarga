import cv2
import numpy as np
from PIL import Image
import os

template = cv2.imread('assets/icons/peduliriwayat.jpg')
if template is None:
    print("Error: Could not find assets/icons/peduliriwayat.jpg")
    exit(1)

big_img = cv2.imread('assets/icons/icons.png')

# The first cell was at x=230, y=80 with w=410, h=460.
cell_x, cell_y = 230, 80
cell_img = big_img[cell_y:cell_y+460, cell_x:cell_x+410]

template_gray = cv2.cvtColor(template, cv2.COLOR_BGR2GRAY)
cell_gray = cv2.cvtColor(cell_img, cv2.COLOR_BGR2GRAY)

res = cv2.matchTemplate(cell_gray, template_gray, cv2.TM_CCOEFF_NORMED)
min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

rel_x, rel_y = max_loc
crop_w, crop_h = template_gray.shape[::-1]

print(f"Template matched at relative offset x={rel_x}, y={rel_y} with size {crop_w}x{crop_h} (confidence {max_val:.4f})")

if max_val < 0.8:
    print("Warning: Low confidence match. The user might have resized the image or changed the background.")

xs = [230, 730, 1230, 1720, 2215]
ys = [80, 555, 1025]

feature_names = [
    'peduliriwayat', 'peduliobat', 'pedulipantau', 'peduliantar', 'ahlipeduli', 
    'pedulidarurat', 'pedulikonsul', 'peduliriwayat_active', 'peduliobat_active', 
    'pedulipantau_active', 'peduliantar_active', 'ahlipeduli_active', 
    'pedulidarurat_active', 'pedulikonsul_active'
]

pil_img = Image.open('assets/icons/icons.png')

idx = 0
for y in ys:
    for x in xs:
        if idx >= 14:
            break
        
        name = feature_names[idx]
        
        crop_x1 = x + rel_x
        crop_y1 = y + rel_y
        crop_x2 = crop_x1 + crop_w
        crop_y2 = crop_y1 + crop_h
        
        cropped = pil_img.crop((crop_x1, crop_y1, crop_x2, crop_y2))
        
        out_name = f'assets/icons/{name}.webp'
        cropped.save(out_name, 'WEBP', lossless=True)
        print(f"Saved {out_name}")
        
        idx += 1

# Delete the jpg since user asked to make it webp again (which we did by overwriting or re-cropping)
os.remove('assets/icons/peduliriwayat.jpg')
print("Deleted peduliriwayat.jpg")
