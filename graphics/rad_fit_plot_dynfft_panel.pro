;+ 
; NAME: 
; RAD_FIT_PLOT_DYNFFT_PANEL
; 
; PURPOSE: 
; This procedure plots the dynamic FFT of a radar parameter in a panel.
;
; The maximum frequency calculated is given by:
;       fMax = 1/(2*dt)
; where dt is the time resolution of the data.
;
; Regularly spaced data is required; see notes on INTERPOLATE keyword for some
; additional info regarding this.
; 
; CATEGORY: 
; Graphics
; 
; CALLING SEQUENCE: 
; RAD_FIT_PLOT_DYNFFT_PANEL
;
; OPTIONAL INPUTS:
; Xmaps: The total number of columns of plots on the resulting page.
; Default is 1.
;
; Ymaps: The total number of rows of plots on the resulting page.
; Default is 1.
;
; Xmap: The current horizontal (column) index of this panel.
; Default is 0.
;
; Ymap: The current vertical (row) index of this panel.
; Default is 0.
;
; KEYWORD PARAMETERS:
; DATE: A scalar or 2-element vector giving the time range to plot, 
; in YYYYMMDD or MMMYYYY format.
;
; TIME: A 2-element vector giving the time range to plot, in HHII format.
;
; LONG: Set this keyword to indicate that the TIME value is in HHIISS
; format rather than HHII format.
;
; PARAM: Set this keyword to specify the parameter to plot. Allowable
; values are 'power', 'velocity', and 'width'.
;
; BEAM: Set this keyword to specify the beam number from which to plot
; the time series.
;
; GATE: Set this keyword to specify the gate number from which to plot
; the time series. If GATE is set to a two-element vector, all rangegates
; inclusive of this vector will be averaged together.
;
; AVG_GATE: Set this keyword to average the values from rangegates when GATE is
; set to a two-element vector.  AVG_GATE is automatically set if GATE is a two-
; element vector, and automatically unset if GATE is a scalar.
;
; CHANNEL: Set this keyword to the channel number you want to plot.
;
; SCAN_ID: Set this keyword to the numeric scan id you want to plot.
;
; FREQ_BAND: Set this keyword to select only radar data taken within a certain
; operating frequency band.  This should be a two-element vector in MHz.
;
; INTERPOLATE: Set this keyword to a time resolution in seconds to interpolate the radar
; data.  Interpolation is required to place radar data onto a regular time grid before
; computing the FFT.  If INTERPOLATE is not set, a default value of 5 seconds is used.
;
; WINDOWLENGTH: Set this keyword to set the length of the time window in seconds over which 
; to compute each FFT.  Default of WINDOWLENGTH = 600 s.
;
; STEPLENGTH: Set this keyword to set the length of the interval between FFT windows.  This valuel defaults to WINDOWLENGTH/2.
;
; COORDS: Set this keyword to a string naming the coordinate system
; of the y axis. Allowable inputs are 'magn', 'geog', 'range' and 'gate'.
; Default is 'gate'.
;
; XRANGE: Set this keyword to manually specify the range of the x axis (in Julian Days).
;
; YRANGE: Set this keyword to change the range of the y axis.  YRANGE is set by default
; to YRANGE=[0,fMax], where fMax = 1/(2*dt) and dt is the time resolution of the input data.
;
; SILENT: Set this keyword to surpress all messages/warnings.
;
; CHARTHICK: Set this keyword to change the font thickness.
;
; CHARSIZE: Set this keyword to change the font size. 
;
; XSTYLE: Set this keyword to change the style of the x axis.
;
; YSTYLE: Set this keyword to change the style of the y axis.
;
; XTITLE: Set this keyword to change the title of the x axis.
;
; YTITLE: Set this keyword to change the title of the y axis.
;
; XTICKS: Set this keyword to change the number of major x tick marks.
;
; XMINOR: Set this keyword to change the number of minor x tick marks.
;
; YTICKS: Set this keyword to change the number of major y tick marks.
;
; YMINOR: Set this keyword to change the number of minor y tick marks.
;
; BAR: Set this keyword to allow for space right of the panel for a colorbar.
;
; XTICKFORMAT: Set this keyword to change the formatting of the time for the x axis.
;
; YTICKFORMAT: Set this keyword to change the formatting of the y axis values.
;
; POSITION: Set this keyword to a 4-element vector of normalized coordinates 
; if you want to override the internal
; positioning calculations.
;
; EXCLUDE: Set this keyword to exclude from plotting data with outside of a specified range.  Keyword should be a two-element vector in the form of EXCLUDE = [minVal, maxVal].  If this keyword is not set, the default value of [-10000, 10000] will be used.
;
; FIRST: Set this keyword to indicate that this panel is the first panel in
; a ROW of plots. That will force Y axis labels.
;
; LAST: Set this keyword to indicate that this is the last panel in a COLUMN of plots.
; That will force X axis labels.
;
; WITH_INFO: Set this keyword to leave some extra space on the top for plotting noise
; and frequency info panels.
;
; ZRANGEOUT: Name of variable to hold the zRange actually used in the plot.  Useful for
; colorbars.
;
; DATAOUT: Set to name of variable to hold the data structure generated by the CALC_DYNFFT
; routine.
;
; EXAMPLE: 
; 
; COPYRIGHT:
; MODIFICATION HISTORY: 
; Written by: Lasse Clausen, 2009; Nathaniel Frissell, 2011
;-
pro RAD_FIT_PLOT_DYNFFT_PANEL, xmaps, ymaps, xmap, ymap         $
    ,date               = date                                  $
    ,time               = time                                  $
    ,long               = long                                  $
    ,param              = param                                 $
    ,beam               = beam                                  $
    ,gate               = gate                                  $
    ,avg_gates          = avg_gates                             $
    ,channel            = channel                               $
    ,scan_id            = scan_id                               $
    ,freq_band          = freq_band                             $
    ,coords             = coords                                $
    ,INTERPOLATE        = interpolate                           $
    ,WINDOWLENGTH       = windowLength                          $
    ,STEPLENGTH         = stepLength                            $
    ,DETREND            = detrend                               $
    ,NORMALIZE          = normalize                             $
    ,XRANGE             = xRange                                $
    ,YRANGE             = yrange                                $
    ,SCALE              = scale                                 $
    ,silent             = silent                                $
    ,bar                = bar                                   $
    ,charthick          = charthick                             $
    ,charsize           = charsize                              $
    ,xstyle             = xstyle                                $
    ,ystyle             = ystyle                                $
    ,xtitle             = xtitle                                $
    ,ytitle             = ytitle                                $
    ,xticks             = xticks                                $
    ,xminor             = xminor                                $
    ,yticks             = yticks                                $
    ,yminor             = yminor                                $
    ,xtickformat        = xtickformat                           $
    ,ytickformat        = ytickformat                           $
    ,xtickname          = xtickname                             $
    ,ytickname          = ytickname                             $
    ,position           = position                              $
    ,exclude            = exclude                               $
    ,first              = first                                 $
    ,last               = last                                  $
    ,with_info          = with_info                             $
    ,no_title           = no_title                              $
    ,title              = title                                 $
    ,ZRANGEOUT          = zRangeOut                             $
    ,NO_TRANSFORM       = no_transform                          $
    ,SCORE              = score                                 $
    ,GAPS               = gaps                                  $
    ,DATAOUT            = dataOut
common rad_data_blk

; get index for current data
data_index = rad_fit_get_data_index()
if data_index eq -1 then $
	return
	
if (*rad_fit_info[data_index]).nrecs eq 0L then begin
	if ~keyword_set(silent) then begin
		prinfo, 'No data in index '+string(data_index)
		rad_fit_info
	endif
	return
endif

if ~keyword_set(param) then $
	param = get_parameter()

if ~is_valid_parameter(param) then begin
	prinfo, 'Invalid plotting parameter: '+param
	return
endif

if n_elements(beam) eq 0 then $
	beam = rad_get_beam()

if n_elements(gate) eq 0 then $
	gate = rad_get_gate()

if n_elements(gate) gt 2 then begin
	prinfo, 'GATE must be scalar or 2-element vector.'
	return
endif

if n_elements(gate) eq 2 and ~keyword_set(avg_gates) then begin
	prinfo, 'GATE is 2-element vector and AVG_GATES not set. Setting AVG_GATES keyword.'
	avg_gates = 1
endif

if n_elements(gate) eq 1 and keyword_set(avg_gates) then begin
	prinfo, 'GATE is scalar and AVG_GATES is set. Unsetting AVG_GATES keyword.'
	avg_gates = 0
endif

if ~keyword_set(freq_band) then $
	freq_band = [3.0, 30.0]

if n_params() lt 4 then begin
	if ~keyword_set(silent) and ~keyword_set(position) then $
		prinfo, 'XMAPS, YMAPS, XMAP and YMAP not set, using default.'
	xmaps = 1
	ymaps = 1
	xmap = 0
	ymap = 0
endif
if ~keyword_set(position) then $
	position = define_panel(xmaps, ymaps, xmap, ymap, bar=bar, with_info=with_info, no_title=no_title)

if ~keyword_set(date) then begin
	if ~keyword_set(silent) then $
		prinfo, 'No DATE given, trying for scan date.'
	caldat, (*rad_fit_data[data_index]).juls[0], month, day, year
	date = year*10000L + month*100L + day
endif

if ~keyword_set(time) then $
	time = [0000,2400]

sfjul, date, time, sjul, fjul, long=long
IF ~KEYWORD_SET(xRange) THEN xrange = [sjul, fjul]

if n_elements(xtitle) eq 0 then $
	_xtitle = 'Time UT' $
else $
	_xtitle = xtitle

if n_elements(xtickformat) eq 0 then $
	_xtickformat = 'label_date' $
else $
	_xtickformat = xtickformat

if n_elements(xtickname) eq 0 then $
	_xtickname = '' $
else $
	_xtickname = xtickname

IF N_ELEMENTS(yTitle) EQ 0 THEN BEGIN
    IF ~KEYWORD_SET(no_transform) THEN BEGIN
        _ytitle = 'Frequency [mHz]'
    ENDIF ELSE BEGIN
        _ytitle = 'Time [s]'
    ENDELSE
ENDIF ELSE _ytitle = ytitle

if n_elements(ytickformat) eq 0 then $
	_ytickformat = '' $
else $
	_ytickformat = ytickformat

if n_elements(ytickname) eq 0 then $
	_ytickname = '' $
else $
	_ytickname = ytickname

if ~keyword_set(scan_id) then $
	scan_id = -1

if n_elements(channel) eq 0 and scan_id eq -1 then begin
	channel = (*rad_fit_info[data_index]).channels[0]
endif

IF ~KEYWORD_SET(interpolate) THEN $
        _interpolate = 5. $
ELSE $
        _interpolate = interpolate

IF ~KEYWORD_SET(yrange) THEN BEGIN
    fMax    = 1. / (2.*_interpolate)
    _yrange = [0,fMax] * 1E3    ;Convert to mHz.
ENDIF ELSE $
    _yrange = yrange

if ~keyword_set(xstyle) then $
	xstyle = 1

if ~keyword_set(ystyle) then $
	ystyle = 1

if ~keyword_set(charsize) then $
	charsize = get_charsize(xmaps, ymaps)

if ~keyword_set(coords) then $
	coords = get_coordinates()

if ~keyword_set(xticks) then $
	xticks = get_xticks(sjul, fjul, xminor=_xminor)

if keyword_set(xminor) then $
	_xminor = xminor

if ~keyword_set(exclude) then $
	exclude = [-10000.,10000.]

; get data
xtag = 'juls'
ytag = param
if ~tag_exists((*rad_fit_data[data_index]), xtag) then begin
	prinfo, 'Parameter '+xtag+' does not exist in RAD_FIT_DATA.'
	return
endif
if ~tag_exists((*rad_fit_data[data_index]), ytag) then begin
	prinfo, 'Parameter '+ytag+' does not exist in RAD_FIT_DATA.'
	return
endif
dd = execute('xdata = (*rad_fit_data[data_index]).'+xtag)
dd = execute('ydata = (*rad_fit_data[data_index]).'+ytag)

; select data to plot
; must fit beam, channel, scan_id, time (roughly) and frequency
;
; check first whether data is available for the user selection
; then find data to actually plot
beam_inds = where((*rad_fit_data[data_index]).beam eq beam, cc)
if cc eq 0 then begin
	if ~keyword_set(silent) then $
		prinfo, 'No data found for beam '+string(beam)
	return
endif
txdata = xdata[beam_inds]
tchann = (*rad_fit_data[data_index]).channel[beam_inds]
ttfreq = (*rad_fit_data[data_index]).tfreq[beam_inds]
tscani = (*rad_fit_data[data_index]).scan_id[beam_inds]
if n_elements(channel) ne 0 then begin
	scch_inds = where(tchann eq channel, cc)
	if cc eq 0 then begin
		if ~keyword_set(silent) then $
			prinfo, 'No data found for for beam '+string(beam)+$
				' and channel '+string(channel)
		return
	endif
endif else if scan_id ne -1 then begin
	scch_inds = where(tscani eq scan_id, cc)
	if cc eq 0 then begin
		if ~keyword_set(silent) then $
			prinfo, 'No data found for for beam '+string(beam)+$
				' and scan_id '+string(scan_id)
		return
	endif
endif
tchann = 0
tscani = 0
txdata = txdata[scch_inds]
ttfreq = ttfreq[scch_inds]
juls_inds = where(txdata ge sjul-10.d/1440.d and txdata le fjul+10.d/1440.d, cc)
if cc eq 0 then begin
	if ~keyword_set(silent) then $
		prinfo, 'No data found for beam '+string(beam)+$
			' and time '+format_time(time)
	return
endif
txdata = 0
ttfreq = ttfreq[juls_inds]
tfre_inds = where(ttfreq*0.001 ge freq_band[0] and ttfreq*0.001 le freq_band[1], cc)
if cc eq 0 then begin
	if ~keyword_set(silent) then $
		prinfo, 'No data found for beam '+string(beam)+$
			' and channel '+string(_channel)+' and time '+format_time(time) + $
			' and freq. band '+string(freq_band)
	return
endif
ttfreq = 0

; get indeces of data to plot
if n_elements(channel) ne 0 then begin
	beam_inds = where((*rad_fit_data[data_index]).beam eq beam and $
		(*rad_fit_data[data_index]).channel eq channel and $
		(*rad_fit_data[data_index]).juls ge sjul-10.d/1440.d and $
		(*rad_fit_data[data_index]).juls le fjul+10.d/1440.d and $
		(*rad_fit_data[data_index]).tfreq*0.001 ge freq_band[0] and $
		(*rad_fit_data[data_index]).tfreq*0.001 le freq_band[1], $
		nbeam_inds)
endif else if scan_id ne -1 then begin
	beam_inds = where((*rad_fit_data[data_index]).beam eq beam and $
		(*rad_fit_data[data_index]).scan_id eq scan_id and $
		(*rad_fit_data[data_index]).juls ge sjul-10.d/1440.d and $
		(*rad_fit_data[data_index]).juls le fjul+10.d/1440.d and $
		(*rad_fit_data[data_index]).tfreq*0.001 ge freq_band[0] and $
		(*rad_fit_data[data_index]).tfreq*0.001 le freq_band[1], $
		nbeam_inds)
endif
if nbeam_inds lt 1 then begin
	prinfo, 'No data found for beam '+string(beam)
	return
endif

if keyword_set(avg_gates) then begin
	tydata = ydata[beam_inds, gate[0]:gate[1]]
	ydata = fltarr(nbeam_inds)
	for b=0, nbeam_inds-1 do begin
		inds = where(tydata[b,*] lt exclude[1] and tydata[b,*] gt exclude[0], nc)
		if nc gt 0 then begin
			ydata[b] = median(tydata[b,inds])
		endif else $
			ydata[b] = 10000.
	endfor
endif else $
	ydata = reform(ydata[beam_inds, gate[0]])


ninds = where(ydata eq 10000., nc, ncomplement=gc)
if gc eq 0L then begin
	prinfo, 'No valid data found.'
	return
endif
if nc ne 0L then $
	ydata[ninds] = !values.f_nan
 
xdata = xdata[beam_inds]

; check if format is sardines.
; if yes, loose the x axis information
; unless it is given
fmt = get_format(sardines=sd, tokyo=ty)
if sd and ~keyword_set(last) then begin
	if ~keyword_set(xtitle) then $
		_xtitle = ' '
	if ~keyword_set(xtickformat) then $
		_xtickformat = ''
	if ~keyword_set(xtickname) then $
		_xtickname = replicate(' ', 60)
endif
if ty and ~keyword_set(first) then begin
	if ~keyword_set(ytitle) then $
		_ytitle = ' '
	if ~keyword_set(ytickformat) then $
		_ytickformat = ''
	if ~keyword_set(ytickname) then $
		_ytickname = replicate(' ', 60)
endif
	
;Place data into structure in order to send to dynFFT routine.
dataStruct      = {time:xdata,data:ydata}
;Calculate the dynamic spectrum.

IF ~KEYWORD_SET(normalize) THEN MAGNITUDE = 1 ELSE MAGNITUDE = 0
dynFFT          = CALC_DYNFFT(dataStruct,INTERPOLATE=_interpolate,WINDOWLENGTH=windowLength,STEPLENGTH=stepLength,NORMALIZE=normalize,DETREND=detrend,MAGNITUDE=magnitude,SCORE=score,GAPS=gaps)

;Trim data that is not going to be plotted for color scales to work properly.
dTime   = dynFFT.time
dFreq   = dynFFT.freq
dFFT    = dynFFT.fft
dWinTime= dynFFT.winTime
dWindowedTimeSeries     = dynFFT.windowedTimeSeries

IF KEYWORD_SET(xRange) THEN BEGIN
    good = WHERE((dTime GE xRange[0]) * (dTime LE xRange[1]))
    dTime = dTime[good]
    dFFT  = dFFT[good,*]
    dWindowedTimeSeries   = dWindowedTimeSeries[good,*]
ENDIF

IF KEYWORD_SET(_yRange) THEN BEGIN
    good = WHERE((dFreq GE _yRange[0]/1000.) * (dFreq LE _yRange[1]/1000.))
    dFreq = dFreq[good]
    dFFT  = dFFT[*,good]
    ;dWindowedTimeSeries   = dWindowedTimeSeries[*,good]
ENDIF

;Add extra frequency and time element to accomodate DRAW_IMAGE commmand.
freqAxis        = [dFreq, MAX(dFreq)+dynFFT.freq[1]]
timeAxis        = [dTime, MAX(dTime)+dynFFT.time[1]-dynFFT.time[0]]
winTime         = dWinTime
nWinTime        = N_ELEMENTS(winTime)
winTimeAxis     = [winTime, 2.*winTime[nWinTime-1] - winTime[nWinTime-2]] * 86400.

IF ~KEYWORD_SET(no_transform) THEN BEGIN
    IF ~KEYWORD_SET(scale) THEN scale = [0,MAX(dFFT)]
    image = GET_COLOR_INDEX(dFFT,COLORSTEPS=GET_NCOLORS(),SCALE=scale,PARAM='power',/STOP)
    image = REFORM(image,SIZE(dFFT,/DIMENSIONS))
    DRAW_IMAGE,image,timeAxis,freqAxis*1E3          $
            ,POSITION       =       position        $
            ,/NO_SCALE                              $
            ,CHARTHICK      =       charthick       $
            ,CHARSIZE       =       charsize        $ 
            ,XSTYLE         =       xstyle          $
            ,YSTYLE         =       ystyle          $
            ,XTITLE         =       _xtitle         $
            ,YTITLE         =       _ytitle         $
            ,XTICKS         =       xticks          $
            ,XMINOR         =       _xminor         $
            ,YTICKS         =       yticks          $
            ,YMINOR         =       yminor          $
            ,XRANGE         =       xrange          $
            ,YRANGE         =       _yrange         $
            ,XTICKFORMAT    =       _xtickformat    $
            ,YTICKFORMAT    =       _ytickformat    $
            ,XTICKNAME      =       _xtickname      $
            ,YTICKNAME      =       _ytickname      $
            ,TITLE          =       title           $
            ,COLOR          =       get_foreground()

    ; return time series for other use
    zRangeOut       = scale

    ;Identify frequency maximum. 
    fftMaxInx = WHERE(dFFT EQ MAX(dFFT))
    fftArrInx = ARRAY_INDICES(dFFT,fftMaxInx)
    nRows     = N_ELEMENTS(fftArrInx[0,*])
    RESOLVE_ROUTINE,'JUL2STRING',/IS_FUNCTION
    FOR kk = 0,nRows-1 DO BEGIN
        timeInx = fftArrInx[0,kk]
        freqInx = fftArrInx[1,kk]
        PRINT,'FFT Max Value'
        PRINT,'   Index: ',fftArrInx[*,kk]
        PRINT,'   FFT Frequency: ' + NUMSTR(dFreq[freqInx]*1000,3) + ' mHz'
        PRINT,'   FFT Time     : ' + JUL2STRING(dTime[timeInx])
        PRINT,'   FFT Magnitude: ' + NUMSTR(dFFT[fftMaxInx[kk]],3)
        PRINT,''
    ENDFOR

ENDIF ELSE BEGIN
    IF ~KEYWORD_SET(scale) THEN BEGIN
        dataMin = MIN(dWindowedTimeSeries)
        dataMax = MAX(dWindowedTimeSeries)
        IF ABS(dataMin) LE ABS(dataMax) THEN BEGIN
            scale       = [-1*ABS(dataMax), ABS(dataMax)]
        ENDIF ELSE BEGIN
            scale       = [-1*ABS(dataMin), ABS(dataMin)]
        ENDELSE
    ENDIF
    image = GET_COLOR_INDEX(dWindowedTimeSeries,COLORSTEPS=GET_NCOLORS(),SCALE = scale,PARAM=param)
    image = REFORM(image,SIZE(dWindowedTimeSeries,/DIMENSIONS))
    DRAW_IMAGE,image,timeAxis,winTimeAxis           $
            ,POSITION       =       position        $
            ,/NO_SCALE                              $
            ,CHARTHICK      =       charthick       $
            ,CHARSIZE       =       charsize        $ 
            ,XSTYLE         =       xstyle          $
            ,YSTYLE         =       ystyle          $
            ,XTITLE         =       _xtitle         $
            ,YTITLE         =       _ytitle         $
            ,XTICKS         =       xticks          $
            ,XMINOR         =       _xminor         $
            ,YTICKS         =       yticks          $
            ,YMINOR         =       yminor          $
            ,XRANGE         =       xrange          $
;            ,YRANGE         =       _yrange         $
            ,XTICKFORMAT    =       _xtickformat    $
            ,YTICKFORMAT    =       _ytickformat    $
            ,XTICKNAME      =       _xtickname      $
            ,YTICKNAME      =       _ytickname      $
            ,TITLE          =       title           $
            ,COLOR          =       get_foreground()

    ; return time series for other use
    zRangeOut       = scale
ENDELSE

    ; returned the actually used scan_id
    if scan_id eq -1 then $
            scan_id = (*rad_fit_info[data_index]).scan_ids[(channel-1) > 0]
    dataOut         = dynFFT
END
