function [data, state] = checkdata(data, varargin);

% CHECKDATA checks the input data of the main FieldTrip functions, e.g. whether
% the type of data strucure corresponds with the required data. If neccessary
% and possible, this function will adjust the data structure to the input
% requirements (e.g. change dimord, average over trials, convert inside from
% index into logical).
%
% If the input data does NOT correspond to the requirements, this function
% is supposed to give a elaborate warning message and if applicable point
% the user to external documentation (link to website).
%
% Use as
%   [data, state] = checkdata(data, ...)
%
% Optional input arguments should be specified as key-value pairs and can
% include
%   datatype            raw, freq, timelock, comp, spike, source, volume, dip
%   dimord              any combination of time, freq, chan, refchan, rpt, subj, chancmb, rpttap
%   senstype            ctf151, ctf275, ctf151_planar, ctf275_planar, neuromag122, neuromag306, bti148, magnetometer, electrode
%   ismeg               yes, no
%   inside              logical, index
%   hastrials           yes, no
%   hasoffset           yes, only for raw data
%   hascumtapcnt        yes  -> this is implied by datatype=freq
%   hascrsspctrm        yes, can be computed from fourier
%   hasfourier          yes
%   csdrepresentation   square, cmb
%   covrepresentation   square, cmb
%
% For some options you can specify multiple values, e.g.
%   [data] = checkdata(data, 'megtype', {'ctf151', 'ctf275'}), e.g. in megrealign
%   [data] = checkdata(data, 'datatype', {'timelock', 'freq'}), e.g. in sourceanalysis

% Copyright (C) 2007, Robert Oostenveld
%
% $Log: checkdata.m,v $
% Revision 1.10  2007/05/30 13:27:00  roboos
% fixed bug for senstype, which did not support multiple options
%
% Revision 1.9  2007/05/30 12:00:24  ingnie
% fixed bug in senstype
%
% Revision 1.8  2007/05/29 16:55:56  ingnie
% added options 'senstype', 'ismeg', 'inside', 'hastrials' and 'hasoffset'
%
% Revision 1.7  2007/05/29 12:54:40  roboos
% updated documentation
%
% Revision 1.6  2007/05/16 11:30:06  roboos
% added check for dimord
%
% Revision 1.5  2007/05/03 07:15:05  roboos
% fixed bug: missing end in loop (thanks to Ali)
%
% Revision 1.4  2007/05/02 16:02:28  roboos
% added dim as a requirement to volume data
% changed the program flow (i.e. the locig) for converting data between different types
% implemented conversion between timelock and raw data
% implemented conversion between source and raw data (will only work for projected lcmv virtual-channel time courses)
%
% Revision 1.3  2007/04/18 10:21:16  roboos
% convert volume to source data if possible
%
% Revision 1.2  2007/04/05 15:35:08  roboos
% less strict on volume data
%
% Revision 1.1  2007/04/03 15:30:05  roboos
% renamed latest copy of checkinput to checkdata, to accomodate the upcoming checkcfg function
%
% Revision 1.7  2007/04/03 06:55:48  jansch
% fixed typo fourier -> fourierspctrm
%
% Revision 1.6  2007/04/02 12:05:02  jansch
% fixed typo
%
% Revision 1.5  2007/03/30 16:50:02  ingnie
% fixed bug; hasfreq also when data does not have time field
%
% Revision 1.4  2007/03/28 16:00:35  roboos
% rewrote most of the function together with Ingrid, implemented feedback and datatype checkdata
%
% Revision 1.3  2007/03/27 09:39:56  ingnie
% only fixdimord implemented
%
% Revision 1.2  2007/02/27 13:35:01  roboos
% added some comments for ingnie to work on
%
% Revision 1.1  2007/02/27 09:24:11  roboos
% initial version that only serves as placeholder for the documentation and some example code
%

% in case of an error this function could use dbstack for more detailled
% user feedback
%
% this function should replace/encapsulate
%   fixdimord
%   fixinside
%   fixprecision
%   fixvolume
%   data2raw
%   raw2data
%   grid2transform
%   transform2grid
%   fourier2crsspctrm
%   freq2cumtapcnt
%   sensortype
%   time2offset
%   offset2time
%
% other potential uses for this function:
%   time -> offset in freqanalysis
%   average over trials
%   csd as matrix


% get the optional input arguments
datatype  = keyval('datatype', varargin);
feedback  = keyval('feedback', varargin); if isempty(feedback), feedback = 'no'; end
dimord    = keyval('dimord', varargin);
senstype  = keyval('senstype', varargin);
ismeg     = keyval('ismeg', varargin);
inside    = keyval('inside', varargin);
hastrials = keyval('hastrials', varargin);
hasoffset = keyval('hasoffset', varargin);
% ...

% determine the type of input data
% this can be raw, freq, timelock, comp, spike, source, volume, dip
israw      = isfield(data, 'label') && isfield(data, 'time') && isa(data.time, 'cell') && isfield(data, 'trial') && isa(data.trial, 'cell');
isfreq     = isfield(data, 'label') && isfield(data, 'freq') && (isfield(data, 'powspctrm') || isfield(data, 'crsspctrm') || isfield(data, 'fourierspctrm'));
istimelock = isfield(data, 'label') && isfield(data, 'time') && ~isfield(data, 'freq') && isfield(data, 'avg') && isnumeric(data.avg);
iscomp     = isfield(data, 'topo') || isfield(data, 'topolabel');
isspike    = isfield(data, 'label') && isfield(data, 'waveform') && isa(data.waveform, 'cell') && isfield(data, 'timestamp') && isa(data.timestamp, 'cell');
isvolume   = isfield(data, 'transform')  && isfield(data, 'dim');
issource   = isfield(data, 'pos');
isdip      = isfield(data, 'dip');

if ~isequal(feedback, 'no')
  if israw
    nchan = length(data.label);
    ntrial = length(data.trial);
    fprintf('the input is raw data with %d channels and %d trials\n', nchan, ntrial);
  elseif isfreq
    nchan = length(data.label);
    nfreq = length(data.freq);
    if isfield(data, 'time'), ntime = num2str(length(data.time));, else ntime = 'no'; end
    fprintf('the input is freq data with %d channels, %d frequencybins and %s timebins\n', nchan, nfreq, ntime);
  elseif istimelock
    nchan = length(data.label);
    ntime = length(data.time);
    fprintf('the input is timelock data with %d channels and %d timebins\n', nchan, ntime);
  elseif iscomp
    ncomp = length(data.label);
    nchan = length(data.topolabel);
    fprintf('the input is component data with %d components and %d original channels\n', ncomp, nchan);
  elseif isspike
    nchan = length(data.label);
    fprintf('the input is spike data\n');
  elseif isvolume
    fprintf('the input is volume data with dimensions [%d %d %d]\n', data.dim(1), data.dim(2), data.dim(3));
  elseif issource
    nsource = size(data.pos, 1);
    fprintf('the input is source data\n');
  elseif isdip
    fprintf('the input is dipole data\n');
  end
end % give feedback

if isfreq || istimelock || iscomp
  % ensure consistency between the dimord string and the axes
  % that describe the data dimensions
  data = fixdimord(data);
end

if ~isempty(datatype)
  if ~isa(datatype, 'cell')
    datatype = {datatype};
  end

  okflag = 0;
  for i=1:length(datatype)
    % check that the data matches with one or more of the required datatypes
    switch datatype{i}
      case 'raw'
        okflag = okflag + israw;
      case 'freq'
        okflag = okflag + isfreq;
      case 'timelock'
        okflag = okflag + istimelock;
      case 'comp'
        okflag = okflag + iscomp;
      case 'spike'
        okflag = okflag + isspike;
      case 'volume'
        okflag = okflag + isvolume;
      case 'source'
        okflag = okflag + issource;
      case 'dip'
        okflag = okflag + isdip;
    end % switch datatype
  end % for datatype

  if ~okflag
    % try to convert the data
    if isequal(datatype, {'source'}) && isvolume
      data = volume2source(data);
      okflag = 1;
    elseif isequal(datatype, {'raw'}) && issource
      data = data2raw(data);
      okflag = 1;
    elseif isequal(datatype, {'raw'}) && istimelock
      data = data2raw(data);
      okflag = 1;
    end
  end % if okflag

  if ~okflag
    % construct an error message
    if length(datatype)>1
      str = sprintf('%s, ', datatype{1:(end-2)});
      str = sprintf('%s%s or %s', str, datatype{end-1}, datatype{end});
    else
      str = datatype{1};
    end
    str = sprintf('This function requires %s data as input.', str);
    error(str);
  end % if okflag
end

if ~isempty(dimord)
  if ~isa(dimord, 'cell')
    dimord = {dimord};
  end

  if isfield(data, 'dimord')
    okflag = any(strcmp(data.dimord, dimord));
  else
    okflag = 0;
  end

  if ~okflag
    % construct an error message
    if length(dimord)>1
      str = sprintf('%s, ', dimord{1:(end-2)});
      str = sprintf('%s%s or %s', str, dimord{end-1}, dimord{end});
    else
      str = dimord{1};
    end
    str = sprintf('This function requires data with a dimord of %s.', str);
    error(str);
  end % if okflag
end

if ~isempty(senstype)
  if ~isa(senstype, 'cell')
    senstype = {senstype};
  end

  if isfield(data, 'grad') || isfield(data, 'elec')
    if any(strcmp(sensortype(data), senstype));
      okflag = 1;
    else
      okflag = 0;
    end
  else
    okflag = 0;
  end
  
  if ~okflag
    % construct an error message
    if length(senstype)>1
      str = sprintf('%s, ', senstype{1:(end-2)});
      str = sprintf('%s%s or %s', str, senstype{end-1}, senstype{end});
    else
      str = senstype{1};
    end
    str = sprintf('This function requires %s data as input, but you are giving %s data.', str, data_senstype);
    error(str);
  end % if okflag
end

if ~isempty(ismeg)
  if isequal(ismeg,'yes')
    okflag = isfield(data, 'grad');
  elseif isequal(ismeg,'no')
    okflag = ~isfield(data, 'grad');
  end

  if ~okflag && isequal(ismeg,'yes')
    str = sprintf('This function requires MEG data with a ''grad'' field');
    error(str);
  elseif ~okflag && isequal(ismeg,'no')
    str = sprintf('This function should not be given MEG data with a ''grad'' field');
    error(str);
  end % if okflag
end

if ~isempty(inside)
  % TODO absorb the fixinside function into this code
  data   = fixinside(data, inside);
  okflag = isfield(data, 'inside');
  
  if ~okflag
    % construct an error message
    str = sprintf('This function requires data with an ''inside'' field.', inside);
    error(str);
  end % if okflag
end

if isequal(hastrials,'yes')
  okflag = isfield(data, 'trial');
  
  if ~okflag
    str = sprintf('This function requires data with a ''trial'' field');
    error(str);
  end % if okflag
end

if isequal(hasoffset,'yes')
  okflag = isfield(data, 'offset');

  if ~okflag && isfield(data, 'time') && isfield(data, 'fsample') && isa(data.time, 'cell')
    for i=1:length(data.time);
      data.offset(i) = time2offset(data.time{i}, data.fsample);
    end
    okflag = 1;
  end
  
  if ~okflag
    str = sprintf('This function requires data with an offset');
    error(str);
  end % if okflag
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert between datatypes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = volume2source(data);
xgrid = 1:data.dim(1);
ygrid = 1:data.dim(2);
zgrid = 1:data.dim(3);
[x y z] = ndgrid(xgrid, ygrid, zgrid);
data.pos = warp_apply(data.transform, [x(:) y(:) z(:)]);

