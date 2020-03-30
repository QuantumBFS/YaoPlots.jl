# Exports plot as jpeg and saves to DEST_DIR

using Images, FileIO


function saveImageAs()
    img = load("/path/to/image.jpg");
    show(img)
    # Save to destination file
    save("/path/to/dest/image.jpg", img);
    save("/path/to/dest/image.png", img);
    save("/path/to/dest/image.gif", img);
end

saveImageAs();

