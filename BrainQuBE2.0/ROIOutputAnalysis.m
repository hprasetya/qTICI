function ROIOutputAnalysis(Img,tot_frame,blushArray,mask)

f = figure;
set(gcf, 'Position', [1 1 1280 800]);
handles = guihandles(f);
handles.ax = axes('Parent',f,'position',[0.05 0.39  0.45 0.54]);
handles.ax2 = axes('Parent',f,'position',[0.52 0.29  0.45 0.64]);
for i = 1:tot_frame
    handles.maskOverImg(:,:,i) = (0.5+mask).*double(Img(:,:,i));
end
% subplot(1,2,1), 
plot(handles.ax,blushArray)
axes(handles.ax); grid on;
nframe = round(tot_frame/2);
axes(handles.ax2);
imshow(Img(:,:,nframe),[]);
handles.sldBottom = uicontrol('Parent',f,'Style','slider','Position',[81,194,549,23],...
    'Value',nframe, 'min',1,'max',tot_frame,'SliderStep',[1/(tot_frame-1)...
    10/(tot_frame-1)],'Callback',@sldBottom_Callback);
handles.txtBottom = sprintf('Frame %d', nframe);
	
bgcolor = get(gcf,'Color');
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,194,23,23],...
'String','1','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[630,194,23,23],...
'String',num2str(tot_frame),'BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[310,165,100,23],...
'String','Frame','BackgroundColor',bgcolor);
guidata(f,handles);
% --- Executes on slider movement.
function sldBottom_Callback(hObject, eventdata, handles)
% hObject    handle to sldBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles = guidata(gcbo);
	sliderValue = get(handles.sldBottom, 'Value');
	toolTipText = sprintf('Frame %d', sliderValue);
	set(handles.sldBottom, 'TooltipString', toolTipText);
	handles.txtBottom = toolTipText;
	handles = SliderCallback(handles);
    guidata(hObject, handles);
	return;
%=====================================================================
function handles = SliderCallback(handles)
	% Get the slider value.
	sliderBottomValue = int32(round(get(handles.sldBottom, 'Value')));
	% Update the label above the sliders.
	newLabel = sprintf('Frame %d', sliderBottomValue);
	handles.txtBottom = newLabel;
	
	% Move the vertical lines to show the new positions.
	PlaceEdgeOnPlot(handles, sliderBottomValue);
	
% 	MakeMeasurements(sliderBottomValue);
	
	% Display the results in the info box.
% 	handles = DisplayResults(handles, resultsArray);
% 	set(handles, 'Pointer', 'arrow');
	return;
%=====================================================================
% Shows vertical lines going up from the X axis to the curve on the plot.
function PlaceEdgeOnPlot(handles, x1)	
persistent handlesToVerticalBars;
axes(handles.ax);  % makes existing axes handles.ax the current axes.
maxYValue = max(ylim);
% Make sure x location is in the valid range along the horizontal X axis.
XRange = get(handles.ax, 'XLim');
maxXValue = XRange(2);
if x1 > maxXValue
    x1 = maxXValue;
end
% Erase the old lines.
if ~isempty(handlesToVerticalBars)
    try
        delete(handlesToVerticalBars);
    catch ME
    end
end
% Draw vertical lines at the slope start and end locations.
hold on;
handlesToVerticalBars(1) = PlaceVerticalBarOnPlot(handles, x1, 'r');

hold off;
axes(handles.ax2);
imshow(handles.maskOverImg(:,:,x1),[]);
	return;	% End of PlaceEdgeOnPlot
	
%=====================================================================
% Shows vertical lines going up from the X axis on the plot.
function lineHandle = PlaceVerticalBarOnPlot(handles, x, lineColor)
% If the plot is visible, plot the line.
axes(handles.ax);  % makes existing axes handles.ax the current axes.
% Make sure x location is in the valid range along the horizontal X axis.
XRange = get(handles.ax, 'XLim');
maxXValue = XRange(2);
if x > maxXValue
    x = maxXValue;
end
% Erase the old line.
%hOldBar=findobj('type', 'hggroup');
%delete(hOldBar);
% Draw a vertical line at the X location.
hold on;
yLimits = ylim;
lineHandle = line([x x], [yLimits(1) yLimits(2)], 'Color', lineColor);
hold off;
return;	% End of PlaceVerticalBarOnPlot