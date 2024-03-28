%raw_data = ones(100,1);
%raw_data(1:2:size(raw_data)) = 0;
%reshape(raw_data, [10 10]);
%frames = formatFrame(raw_data);
%timedFrames = addTimestamps(frames);
%data = unformatFrame(frames);

function layer2(data)
    %frames = formatFrame(data);
    %timedFrames = cast(addTimestamps(frames), "double");
    %assignin('base', 'simin', timedFrames');
    %sim("tp5_5_emetteur_template_usrp.slx");
    data = unformatFrame(data);
    assignin('base', 'image', data);
end

function frames = formatFrame(raw_data)
    raw_data = raw_data(:);
    raw_data_size = size(raw_data);

    N = 36;
    r = 0.25;
    N_util = N*(1-r); % nb of util qpsk symbols
    Nb_util = N_util*2; % nb of util bits in an OFDM symbol
    t = 10; % frame size
    s = t-2; % nb of util symbols

    raw_data(end+(Nb_util*s-mod(raw_data_size(1), Nb_util*s)), :) = 0;
    data = reshape(raw_data, Nb_util*s, []);
    data_size = size(data);

    preamble = 0:data_size(2)-1;
    preamble = dec2bin(preamble, Nb_util);
    preamble = num2cell(preamble');
    preamble = char(preamble);
    preamble = reshape(str2num(preamble), Nb_util, []);

    frames = [preamble ; data];
end

function data = unformatFrame(frame)
    N = 36;
    r = 0.25;
    N_util = N*(1-r); % nb of util qpsk symbols
    Nb_util = N_util*2; % nb of util bits in an OFDM symbol
    t = 10; % frame size
    s = t-2; % nb of util symbols

    frame_size = size(frame, 1);
    assert(mod(frame_size, Nb_util*(s+1)) == 0);
    data = reshape(frame, Nb_util*(s+1), []);
    data = data(Nb_util+1:end,:);

    % Assuming we know the size of the image
    % TODO: send the size in the first frame
    image_size = 10;
    data = data(:);
    data = data(1:image_size*image_size);
    data = reshape(data, [image_size image_size]);
    data = cast(data, "uint8");
end

function timedFrames = addTimestamps(frames)
    T_s = 1.8e-4;
    t = 10;
    T_t = t*T_s;

    mul = 0:size(frames, 2)-1;
    times = mul*T_t;

    timedFrames = [times ; frames];
end