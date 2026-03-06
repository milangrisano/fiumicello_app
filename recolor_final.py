from PIL import Image

def recolor_safely(source_path, target_path, output_path):
    try:
        source_img = Image.open(source_path).convert("RGBA")
        target_img = Image.open(target_path).convert("RGBA")
        
        if source_img.size != target_img.size:
            target_img = target_img.resize(source_img.size, Image.Resampling.LANCZOS)
            
        source_data = list(source_img.getdata())
        target_data = list(target_img.getdata())
        
        new_data = []
        
        for s_pixel, t_pixel in zip(source_data, target_data):
            sr, sg, sb, sa = s_pixel
            tr, tg, tb, ta = t_pixel
            
            # Identify fills in source
            is_green_src = sg > sr + 20 and sg > sb + 20 and sa > 20
            is_red_src = sr > sg + 20 and sr > sb + 20 and sa > 20
            # Identify white: all channels high and roughly equal
            is_white_src = sr > 200 and sg > 200 and sb > 200 and sa > 20
            
            # If the target is highly transparent, it's NOT a line. We can safely color it.
            # If it's a line, 'ta' will be high (e.g. > 50).
            if ta < 50:
                if is_green_src or is_red_src or is_white_src:
                    new_data.append(s_pixel)
                else:
                    new_data.append(t_pixel)
            else:
                # It's a gold line/edge, keep the target pixel!
                new_data.append(t_pixel)
                
        target_img.putdata(new_data)
        target_img.save(output_path)
        print("Success")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    recolor_safely(
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo.png",
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo_gold.png",
        r"c:\Users\milan\Documents\dev\fiumicello_app\assets\images\logo_gold.png"
    )
