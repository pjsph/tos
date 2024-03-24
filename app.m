function app(type, path)
    if type == "sender"
        image = loadImage(path);
        layer2(image);
    elseif type == "receiver"
        %TODO
    else
        error("Usage: app <sender|receiver> <image_path>");
    end
end

function image = loadImage(path)
    [image, cmap] = imread(path);
    assert(isequal(size(image), [10 10]));
end

function saveImage(image, path)
    assert(isequal(size(image), [10 10]));
    imwrite(image, [1 1 1 ; 0 0 0], path);
end