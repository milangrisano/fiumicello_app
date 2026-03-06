from PIL import Image

def recolor_logo(source_path, target_path, output_path):
    try:
        source_img = Image.open(source_path).convert("RGBA")
        target_img = Image.open(target_path).convert("RGBA")
        
        w, h = target_img.size
        
        # We work on target_img in place for the fills
        # First, let's copy the green and red fills from logo.png to logo_gold.png
        # The lines in logo.png are approx (33, 32, 30).
        
        s_data = source_img.load()
        t_data = target_img.load()
        
        for x in range(w):
            for y in range(h):
                sr, sg, sb, sa = s_data[x, y]
                
                # Check if it's opaque in source
                if sa > 50:
                    # Check if it's NOT a line (lines are dark grey)
                    # Use a generous threshold to catch anti-aliased grey
                    # If it's bright or colorful, it's a fill
                    is_line = (sr < 60 and sg < 60 and sb < 60)
                    
                    if not is_line:
                        # It's green or red fill, copy the source pixel over!
                        t_data[x, y] = s_data[x, y]
        
        # Now flood-fill the middle gap with White.
        # Starting point (430, 200) is safely inside the transparent gap between green and red.
        # We fill 'transparent' pixels with white.
        stack = [(430, 200)]
        visited = set()
        
        while stack:
            cx, cy = stack.pop()
            if (cx, cy) in visited:
                continue
                
            visited.add((cx, cy))
            
            if cx < 0 or cx >= w or cy < 0 or cy >= h:
                continue
                
            tr, tg, tb, ta = t_data[cx, cy]
            
            # If it's transparent, color it white and add neighbors
            if ta < 50:
                t_data[cx, cy] = (255, 255, 255, 255)
                # Keep expanding
                stack.append((cx+1, cy))
                stack.append((cx-1, cy))
                stack.append((cx, cy+1))
                stack.append((cx, cy-1))
        
        target_img.save(output_path)
        print("Success")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    recolor_logo(
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo.png",
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo_gold.png",
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo_gold.png"
    )
