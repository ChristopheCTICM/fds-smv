% McDermott
% 9-18-12
% ribbed_channel.m

close all
clear all

datadir = '../../Verification/Turbulence/';
plotdir = '../../Manuals/FDS_Verification_Guide/SCRIPT_FIGURES/';

plot_style

nx = [20 40 80 160];
lnx = length(nx);
h = 0.1;
C_nu = 0.1;
dx = 1./nx;
fds_marker = {'r+-' 'c^-' 'g>-' 'k-'};
fds_key = {'FDS $h/\delta x = 2$' 'FDS $h/\delta x = 4$' 'FDS $h/\delta x = 8$' 'FDS $h/\delta x = 16$'};

if ~exist([datadir,'ribbed_channel_data.csv'])
    display(['Error: File ' [datadir,'ribbed_channel_data.csv'] ' does not exist. Skipping case.'])
    return
end
for i=1:lnx
    if ~exist([datadir,'ribbed_channel_',num2str(nx(i)),'_line.csv'])
        display(['Error: File ' [datadir,'ribbed_channel_',num2str(nx(i)),'_line.csv'] ' does not exist. Skipping case.'])
        return
    end
end

% read experimental and FDS data files

D = importdata([datadir,'ribbed_channel_data.csv'],',',1);
for i=1:lnx
    M{i} = importdata([datadir,'ribbed_channel_',num2str(nx(i)),'_line.csv'],',',2);
end

% organize and plot streamwise U along bottom of channel

j = find(strcmp(D.colheaders,'x/h U strm'));
xoh = D.data(:,j);
j = find(strcmp(D.colheaders,'U strm'));
u_data = D.data(:,j);

figure
H(1)=plot(xoh,u_data,'bo'); hold on

for i=1:lnx
    j = find(strcmp(M{i}.colheaders,'u_strm_bot-x'));
    x = M{i}.data(:,j);
    I = find(x<0);
    x(I) = x(I) + 1;
    [x I] = sort(x);
    
    j = find(strcmp(M{i}.colheaders,'u_strm_bot'));
    u_fds = M{i}.data(:,j);
    u_fds = u_fds(I);
    
    H(1+i)=plot(x/h,u_fds,fds_marker{i});
end

xlabel('$x/h$','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)
ylabel('Streamwise Velocity (m/s)','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)

axis([0 10 -0.8 0.8])
set(gca,'YTick',-0.8:0.4:0.8)
set(gca,'YTickLabel',-0.8:0.4:0.8)

set(gca,'Units',Plot_Units)
set(gca,'FontName',Font_Name)
set(gca,'FontSize',Title_Font_Size)
set(gca,'Position',[Plot_X,Plot_Y,Plot_Width,Plot_Height])

lh = legend(H,'PIV data',fds_key{1:lnx},'Location','Northwest');
set(lh,'Interpreter',Font_Interpreter)

% add SVN if file is available

SVN_Filename = [datadir,'ribbed_channel_',num2str(nx(1)),'_svn.txt'];
if exist(SVN_Filename,'file')
    SVN = importdata(SVN_Filename);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = x_lim(1)+SVN_Scale_X*(x_lim(2)-x_lim(1));
    Y_SVN_Position = y_lim(1)+SVN_Scale_Y*(y_lim(2)-y_lim(1));
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter',Font_Interpreter)
end

% print to pdf

set(gcf,'Visible',Figure_Visibility);
set(gcf,'PaperUnits',Paper_Units);
set(gcf,'PaperSize',[Paper_Width Paper_Height]);
set(gcf,'PaperPosition',[0 0 Paper_Width Paper_Height]);
print(gcf,'-dpdf',[plotdir,'ribbed_channel_u_strm'])

% streamwise urms along bottom of channel

j = find(strcmp(D.colheaders,'x/h urms strm'));
xoh = D.data(:,j);
j = find(strcmp(D.colheaders,'urms strm'));
urms_data = D.data(:,j);

figure
H(1)=plot(xoh,urms_data,'bo'); hold on

for i=1:lnx
    j = find(strcmp(M{i}.colheaders,'urms_strm_bot-x'));
    x = M{i}.data(:,j);
    I = find(x<0);
    x(I) = x(I) + 1;
    [x I] = sort(x);
    
    j = find(strcmp(M{i}.colheaders,'urms_strm_bot'));
    urms_fds = M{i}.data(:,j);
    urms_fds = urms_fds(I);
    
    H(1+i)=plot(x/h,urms_fds,fds_marker{i});
end

xlabel('$x/h$','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)
yh = ylabel('Streamwise RMS Velocity (m/s)','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size);
set(yh,'Position',[-0.8194-.2    0.2963-.025    1.0001])

axis([0 10 0 0.6])

set(gca,'Units',Plot_Units)
set(gca,'FontName',Font_Name)
set(gca,'FontSize',Title_Font_Size)
set(gca,'Position',[Plot_X,Plot_Y,Plot_Width,Plot_Height])

lh = legend(H,'PIV data',fds_key{1:lnx},'Location','Northwest');
set(lh,'Interpreter',Font_Interpreter)

% add SVN if file is available

SVN_Filename = [datadir,'ribbed_channel_',num2str(nx(1)),'_svn.txt'];
if exist(SVN_Filename,'file')
    SVN = importdata(SVN_Filename);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = x_lim(1)+SVN_Scale_X*(x_lim(2)-x_lim(1));
    Y_SVN_Position = y_lim(1)+SVN_Scale_Y*(y_lim(2)-y_lim(1));
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter',Font_Interpreter)
end

% print to pdf

set(gcf,'Visible',Figure_Visibility);
set(gcf,'PaperUnits',Paper_Units);
set(gcf,'PaperSize',[Paper_Width Paper_Height]);
set(gcf,'PaperPosition',[0 0 Paper_Width Paper_Height]);
print(gcf,'-dpdf',[plotdir,'ribbed_channel_urms_strm'])

% streamwise U profile at x/h=0 (center of rib)

j = find(strcmp(D.colheaders,'y/h U prof'));
yoh = D.data(:,j);
j = find(strcmp(D.colheaders,'U prof'));
u_data = D.data(:,j);

figure
H(1)=plot(u_data,yoh,'bo'); hold on

for i=1:lnx
    j = find(strcmp(M{i}.colheaders,'u_prof_rib-z'));
    y = M{i}.data(:,j);
    
    j = find(strcmp(M{i}.colheaders,'u_prof_rib'));
    u_fds = M{i}.data(:,j);
    
    H(1+i)=plot(u_fds,y/h,fds_marker{i});
end

ylabel('$z/h$','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)
xlabel('Streamwise Velocity (m/s)','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)

axis([0 2 1 3])

set(gca,'Units',Plot_Units)
set(gca,'FontName',Font_Name)
set(gca,'FontSize',Title_Font_Size)
set(gca,'Position',[Plot_X,Plot_Y,Plot_Width,Plot_Height])

lh = legend(H,'PIV data',fds_key{1:lnx},'Location','Northwest');
set(lh,'Interpreter',Font_Interpreter)

% add SVN if file is available

SVN_Filename = [datadir,'ribbed_channel_',num2str(nx(1)),'_svn.txt'];
if exist(SVN_Filename,'file')
    SVN = importdata(SVN_Filename);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = x_lim(1)+SVN_Scale_X*(x_lim(2)-x_lim(1));
    Y_SVN_Position = y_lim(1)+SVN_Scale_Y*(y_lim(2)-y_lim(1));
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter',Font_Interpreter)
end

% print to pdf

set(gcf,'Visible',Figure_Visibility);
set(gcf,'PaperUnits',Paper_Units);
set(gcf,'PaperSize',[Paper_Width Paper_Height]);
set(gcf,'PaperPosition',[0 0 Paper_Width Paper_Height]);

print(gcf,'-dpdf',[plotdir,'ribbed_channel_u_prof'])

% streamwise urms profile at x/h=0 (center of rib)

j = find(strcmp(D.colheaders,'y/h urms prof'));
yoh = D.data(:,j);
j = find(strcmp(D.colheaders,'urms prof'));
urms_data = D.data(:,j);

figure
H(1)=plot(urms_data,yoh,'bo'); hold on

for i=1:lnx
    j = find(strcmp(M{i}.colheaders,'urms_prof_rib-z'));
    y = M{i}.data(:,j);
    
    j = find(strcmp(M{i}.colheaders,'urms_prof_rib'));
    urms_fds = M{i}.data(:,j);
    
    H(1+i)=plot(urms_fds,y/h,fds_marker{i});
end

ylabel('$z/h$','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)
xlabel('Streamwise RMS Velocity (m/s)','Interpreter',Font_Interpreter,'Fontsize',Label_Font_Size)

axis([0 1 1 3])

set(gca,'Units',Plot_Units)
set(gca,'FontName',Font_Name)
set(gca,'FontSize',Title_Font_Size)
set(gca,'Position',[Plot_X,Plot_Y,Plot_Width,Plot_Height])

lh = legend(H,'PIV data',fds_key{1:lnx},'Location','Northeast');
set(lh,'Interpreter',Font_Interpreter)

% add SVN if file is available

SVN_Filename = [datadir,'ribbed_channel_',num2str(nx(1)),'_svn.txt'];
if exist(SVN_Filename,'file')
    SVN = importdata(SVN_Filename);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = x_lim(1)+SVN_Scale_X*(x_lim(2)-x_lim(1));
    Y_SVN_Position = y_lim(1)+SVN_Scale_Y*(y_lim(2)-y_lim(1));
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter',Font_Interpreter)
end

% print to pdf

set(gcf,'Visible',Figure_Visibility);
set(gcf,'PaperUnits',Paper_Units);
set(gcf,'PaperSize',[Paper_Width Paper_Height]);
set(gcf,'PaperPosition',[0 0 Paper_Width Paper_Height]);
print(gcf,'-dpdf',[plotdir,'ribbed_channel_urms_prof'])






