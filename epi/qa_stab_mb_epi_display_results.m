function qa_stab_mb_epi_display_results(RES, PARAMS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to display the results generated by qa_stab_mb_epi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define display default params
figpos = [1 1 21 23]; 
figure('units','centimeters','position',figpos,'color',[1 1 1]);
unit_fontsize = 8;
title_fontsize = 11;
label_fontsize = 10;
def_fontname = 'Times';
gca_width = 5;
gca_height = 5;
gca_gap_h = 1.5;
gca_gap_v = 2;

% define some hardcoded parameters:
N_max = 21; % maximal length of rectangular ROI edge
sect = round([PARAMS.PE_lin/2 PARAMS.RO_col/2 PARAMS.nslices/2]); 

% plot motion in the y-direction (PE)
subplot(3,3,1);
gposx = 1;
gposy = 1;
plot(1:PARAMS.nvols, RES.SPAT.y_motion,'r');
title('Motion in y-direction (PE)','fontname',def_fontname,'fontsize',title_fontsize);
xlabel(['Volume (TR=' num2str(PARAMS.TR) 'ms)'],'fontname',def_fontname,'fontsize',label_fontsize);
ylabel('Translation (mm)','fontname',def_fontname,'fontsize',label_fontsize);
set(gca,'units','centimeters','position',[gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height]);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);

% display the SNR map 
subplot(3,3,2);
gposx = 1.92;
gposy = 1;
gcapos = [gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height];
if isfield(RES.SNR, 'snrmap')
    A = eb_orthviews(fullfile(PARAMS.outdir,RES.SNR.snrmap), sect(1), sect(2), sect(3));
    titl = 'SNR map';
else
    A = eb_orthviews(fullfile(PARAMS.outdir,RES.SPAT.meanim), sect(1), sect(2), sect(3));
    titl = 'Mean image';
end
imshow(A,[]);
colorbar('position',[(gcapos(1)+gcapos(3))*1.01/figpos(3) gcapos(2)/figpos(4) 0.02 gcapos(4)/figpos(4)])
set(gca,'units','centimeters','position',gcapos);
title(titl,'fontname',def_fontname,'fontsize',title_fontsize);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);
tmpx = get(gca,'XLim');
tmpy = get(gca,'YLim');
text(tmpx(2)/2,-tmpy(2)/3,[PARAMS.date ' (' PARAMS.comment ')'],'fontname',def_fontname,'fontsize',12,'horizontalalignment','center');

% display the tSNR map 
subplot(3,3,3);
gposx = 2.98;
gposy = 1;
gcapos = [gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height];
A = eb_orthviews(fullfile(PARAMS.outdir,RES.FBIRN.tsnrmap), sect(1), sect(2), sect(3));
imshow(A,[]);
colorbar('position',[(gcapos(1)+gcapos(3))*1.01/figpos(3) gcapos(2)/figpos(4) 0.02 gcapos(4)/figpos(4)])
set(gca,'units','centimeters','position',gcapos);
title('tSNR map','fontname',def_fontname,'fontsize',title_fontsize);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);

% display SD over all volumes
subplot(3,3,4);
gposx = 1;
gposy = 2;
stdvol = spm_read_vols(spm_vol(fullfile(PARAMS.outdir,RES.FBIRN.sdmap)));
dim = size(stdvol);
montage(reshape(stdvol,[dim(1),dim(2),1,dim(3)]));
caxis([min(stdvol(:)), max(stdvol(:))*0.75]);
title('SD of time series (w/o detrending)','fontname',def_fontname,'fontsize',title_fontsize);
set(gca,'units','centimeters','position',[gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height]);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);
colormap('jet');

% Image intensity drift plot
subplot(3,3,5);
gposx = 2;
gposy = 2;
plot(1:PARAMS.nvols, RES.FBIRN.data_drift_plot);hold on;
plot(1:PARAMS.nvols, RES.FBIRN.fit_drift_plot,'r');
title('Drift','fontname',def_fontname,'fontsize',title_fontsize);
xlabel(['Volume (TR=' num2str(PARAMS.TR) 'ms)'],'fontname',def_fontname,'fontsize',label_fontsize);
ylabel('Signal (a.u.)','fontname',def_fontname,'fontsize',label_fontsize);
set(gca,'units','centimeters','position',[gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height]);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);

% Fluctuation plot
subplot(3,3,6);
gposx = 3;
gposy = 2;
plot(1:PARAMS.nvols, RES.FBIRN.perc_fluct_plot);
title('Fluctuations (after detrending)','fontname',def_fontname,'fontsize',title_fontsize);
xlabel(['Volume (TR=' num2str(PARAMS.TR) 'ms)'],'fontname',def_fontname,'fontsize',label_fontsize);
ylabel('Signal (%)','fontname',def_fontname,'fontsize',label_fontsize);
set(gca,'YLim',[-0.6 0.6]);
set(gca,'units','centimeters','position',[gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height]);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);

% FFT of residuals
subplot(3,3,7);
gposx = 1;
gposy = 3;
plot(RES.FBIRN.fcoord, RES.FBIRN.FT_resid);
title('FFT of residuals (after detrending)','fontname',def_fontname,'fontsize',title_fontsize);
xlabel('Frequency (Hz)','fontname',def_fontname,'fontsize',label_fontsize);
ylabel('Magnitude (relative to mean signal)','fontname',def_fontname,'fontsize',label_fontsize);
set(gca,'units','centimeters','position',[gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width*2 gca_height]);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);
set(gca,'XLim',[min(RES.FBIRN.fcoord) max(RES.FBIRN.fcoord)]);

% Weiskoff test and RDC value
subplot(3,3,9);
gposx = 3;
gposy = 3;
loglog((1:N_max), (RES.FBIRN.SFNR),'g');hold on;
loglog((1:N_max), (RES.FBIRN.SFNR(1)*(1:N_max)),'b');
title('Weiskoff plot','fontname',def_fontname,'fontsize',title_fontsize);
xlabel('Length of square ROI (in voxels)','fontname',def_fontname,'fontsize',label_fontsize);
ylabel('SFNR','fontname',def_fontname,'fontsize',label_fontsize);
set(gca,'units','centimeters','position',[gca_gap_h*gposx+gca_width*(gposx-1) gca_gap_v*(3-gposy+1)+gca_height*(3-gposy) gca_width gca_height]);
set(gca,'fontname',def_fontname,'fontsize',unit_fontsize);
set(gca,'XLim',[1 N_max]);

% save summary figure
set(gcf,'PaperPositionMode','auto')
print(gcf,'-dpng',fullfile(PARAMS.outdir, [PARAMS.resfnam '.png']));
%saveas(gcf,fullfile(QA.outputdir, [PARAMS.resfnam '.fig']));


return;


