raw_data = ones(10000,1);
raw_data(1:2:size(raw_data)) = 0;
reshape(raw_data, [100 100]);
frames = formatFrame(raw_data);

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

    data = [preamble ; data];
    size(data)

    frames = []
end