from PIL import Image

def is_gold(r, g, b, a):
    # Base gold color is ~ (212, 175, 55) or similar.
    # We can detect 'gold-ish' colors. They are mostly yellow-orange.
    if a < 50: 
        return False
    # Typical gold has more red than green, and more green than blue
    # But it might be darker. Let's just say it's yellow/brown.
    if r > 100 and g > 80 and b < 150 and r > b and g > b:
        return True
    # Darker gold/brown
    if r > 50 and g > 40 and b < 100 and r > b and g > b:
        return True
    return False

def safely_transfer_colors(source_path, target_path, output_path):
    try:
        source_img = Image.open(source_path).convert("RGBA")
        target_img = Image.open(target_path).convert("RGBA")
        
        if source_img.size != target_img.size:
            print("Resizing target image...")
            target_img = target_img.resize(source_img.size, Image.Resampling.LANCZOS)
            
        source_data = source_img.getdata()
        target_data = target_img.getdata()
        
        new_data = []
        
        for s_pixel, t_pixel in zip(source_data, target_data):
            sr, sg, sb, sa = s_pixel
            tr, tg, tb, ta = t_pixel
            
            # Identify green in source
            is_green_src = sg > sr + 20 and sg > sb + 20 and sa > 50
            # Identify red in source
            is_red_src = sr > sg + 20 and sr > sb + 20 and sa > 50
            # Identify white in source
            is_white_src = sr > 200 and sg > 200 and sb > 200 and sa > 50
            
            # Identify if target pixel is "gold" line
            is_target_gold = is_gold(tr, tg, tb, ta)
            
            # Also, if target pixel has very high alpha and isn't transparent, it might be a line. 
            # But wait, original logo_gold might have a transparent background or white background.
            # We want to ONLY overwrite if it's NOT a gold line.
            
            if (is_green_src or is_red_src or is_white_src) and not is_target_gold:
                # But wait, if source is white, and we paste it, it might overwrite transparent background correctly.
                # However we only want to color the 'box' in the middle. 
                # Let's assume the green, red, and white are part of the box or logo background.
                new_data.append(s_pixel)
            else:
                new_data.append(t_pixel)
                
        target_img.putdata(new_data)
        target_img.save(output_path)
        print("Success")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    safely_transfer_colors(
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo.png",
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo_gold.png",
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo_gold.png"
    )
