function get_MPT(varargin)
extension='mpt';directory=ls(['*.' extension]);
if nargin
    if ~iscell(varargin{1})
        directory=ls([varargin{:} '.' extension]);
    else
        beep;keyboard;return
    end
end
fclose all;scalecur(1e-3,0);scalecap(1,0);
savefig=1;saveeps=0;
dirname=regexp(pwd, '\', 'split');dirname=dirname{end};
%multiWaitbar([dirname ' :' num2str(size(directory,1)) ' files'],0);

for i=1:size(directory,1)
    close all;fprintf('\n')
    %multiWaitbar([dirname ' :' num2str(size(directory,1)) ' files'],i/size(directory,1));
    filename=strtrim(directory(i,:));
    name=filename(1:end-1-length(extension)); %delete([name '.mpt']);continue
    
    if 0&&exist([pwd '\' name '.mat'],'file') %matfile already exists, option to skip MPT_import
        fprintf([num2str(i) '/' num2str(size(directory,1)) ': ' filename(1:end-4) ' skipping MPT_import'])
        load([name '.mat']);
    else
        fprintf([num2str(i) '/' num2str(size(directory,1)) ': ' filename(1:end-4)])
        try [h, d]=MPT_import(filename);
        catch exception;
            fprintf([ ' | ' 'MPT_import FAILED: ' exception.identifier]); continue;
        end
    end
    
    if isempty(d.table), fprintf( ' | MPT_import FAILED: empty table'); continue;end
    
    if h.eleArea{1}==0.001, h.eleArea{1}=1;h.eleArea{2}='cm²';end
    if h.eleMass{1}==0.001, h.eleMass{1}=1;h.eleMass{2}='g';end
    switch lower(h.type)
        case {'cyclic voltammetry',...
                'cyclic voltammetry advanced'}%covers ADVANCED too BUT THIS SHOULD CHANGE*********************
            [t, ~]   =dtextract(d,'time');   d.table=sortrows(d.table,t); t=d.table(:,t);
            %[P, d.Pu]=dtextract(d,'P');P=d.table(:,P);
            if ~cv_curves(d.table(:,dtextract(d,'cycle number'))), fprintf(' |  Empty!');continue;end
            [V, d.Vu]=dtextract(d,'Ewe');V=d.table(:,V);
            [I, d.Iu]=dtextract(d,'<I>');I=d.table(:,I);
            if isempty(I), [I, d.Iu]=dtextract(d,'I/');I=d.table(:,I);end
            %I=medfilt1(I);%seems to take care of the spikes!
            %[tV, tI]=trimVI(h,V,I);[aV, aI]=aveVI(h,tV,tI);%tI=remove_outliers(tI,3);% old way, functions obsolete
            [aV, tI]=Vsort(h,V,I);if isempty(tI),fprintf(' | Vsort FAILED: not enough points');continue;end
            aI=tI(:,end);% just taking the last value right now. For average is aI=mean(tI,2);
            
            %three electrode option
            [Vc, d.Vu]=dtextract(d,'Ece');Vc=d.table(:,Vc);
            if ~isempty(Vc) %Ece present in MPT
                if norm(V-Vc)>max(V)/1000 % its values are not trivial
                    [Vwe, Iwe, Vce, Ice]=Vsort(h,V-Vc,I,-Vc);
                    try dataCV=plot_dataCVe(h,aV,aI,Vwe,Iwe,Vce,Ice,name,1);
                    catch exception
                        fprintf([' | plot_dataCV FAILED: ' exception.identifier]);
                        save(name,'h','d','aV','tI'); continue;
                    end
                end
            else
                try dataCV=plot_dataCV(h,aV,aI,name,1);
                catch exception
                    fprintf([' | plot_dataCV FAILED: ' exception.identifier]);
                    save(name,'h','d','aV','tI'); continue;
                end
            end
            
            %plotVI(tV,tI/(h.tec.dE_dt/1e3),aV,aI/(h.tec.dE_dt/1e3),name);
            save(name,'h','d','aV','aI','dataCV');
            switch length(get(0,'children'))
                case 1
                    if saveeps, saveas(gcf,[name '.eps'],'eps2c');end
                    if savefig, saveas(gcf,[name '.fig'],'fig');end;close
                case 2
                    if saveeps, saveas(gcf,[name '_3E.eps'],'eps2c');end
                    if savefig, saveas(gcf,[name '_3E.fig'],'fig');end;close
                    if saveeps, saveas(gcf,[name '.eps'],'eps2c');end
                    if savefig, saveas(gcf,[name '.fig'],'fig');end;close
            end
            
        case {'galvanostatic cycling with potential limitation',...
                'galvanostatic cycling with potential limitation 5'}
            [t, ~]   =dtextract(d,'time');   d.table=sortrows(d.table,t); t=d.table(:,t);
            %[P, d.Pu]=dtextract(d,'P');      P=d.table(:,P);
            [V, d.Vu]=dtextract(d,'Ewe');    V=d.table(:,V);
            %[q, d.Qu]=dtextract(d,'dq');     q=d.table(:,q);
            [I, d.Iu]=dtextract(d,'<I>');    I=d.table(:,I);
            if isempty(I), [I, d.Iu]=dtextract(d,'I/');I=d.table(:,I);end
            [h.curves, d.ctrl]=dtextract(d,'control changes');     h.curves=d.table(:,h.curves);
            
            try dataGS=plotGS_data(h,t,V,name,1);
            catch exception;
                fprintf([' | ' 'plotGS_data FAILED: ' exception.identifier]);
                save(name,'h','d','V','I','t'); continue;
            end
            save(name,'h','d','V','I','t','dataGS');
            if ~isempty(get(0,'children'))
                if saveeps, saveas(gcf,[name '.eps'],'eps2c');end
                if savefig, saveas(gcf,[name '.fig'],'fig');end
            end;close
            
        case 'potentio electrochemical impedance spectroscopy'
            [f, ~]  =dtextract(d,	  'freq');  f=d.table(:,f);
            [ReZ, ~]=dtextract(d,   'Re\(Z\)');  ReZ=  d.table(:,ReZ);
            [ImZ, ~]=dtextract(d,  '-Im\(Z\)');  ImZ= -d.table(:,ImZ);
            %[AbZ, ~]=dtextract(d,     '\|Z\|');  AbZ=  d.table(:,AbZ);
            %[PhZ, ~]=dtextract(d,'Phase\(Z\)');  PhZ=  d.table(:,PhZ);
            Eh=h.tec.E;Et=h.tec.tE;
            if length(h.tec.ncCycles)>1 %multi-stack (I hate Kristy)
                f=f(1:end/2,:);beep;fprintf([' | ' 'Stacked steps. Using 1st.']);
                ReZ=ReZ(1:end/2,:);ImZ=ImZ(1:end/2,:);%AbZ=AbZ(1:end/2,:);PhZ=PhZ(1:end/2,:);
                Eh=h.tec.E(1);Et=h.tec.tE(1);h.tec.ncCycles=h.tec.ncCycles(1);
            end
            fnum=length(f)/(h.tec.ncCycles+1);
            if h.tec.ncCycles>0 && isequal(f(1:fnum),f(1+fnum:end)) %multi-pass
                f=f(1:fnum);beep;fprintf([' | ' 'Multiple passes. Using average.']);
                ReZ=reshape(ReZ,fnum,2);ImZ=reshape(ImZ,fnum,2); ReZ=mean(ReZ,2);ImZ=mean(ImZ,2);
                %AbZ=reshape(AbZ,fnum,2);PhZ=reshape(PhZ,fnum,2); AbZ=mean(AbZ,2);PhZ=mean(PhZ,2);
            end
            
            try dataZ=plotZ_Bode(h,f,ReZ,ImZ,name);%
            catch exception;
                fprintf([' | ' 'plotZ_Bode FAILED: ' exception.identifier]);
                save(name,'h','d','f','ReZ','ImZ','Eh','Et');continue;
            end
            save(name,'h','d','f','ReZ','ImZ','dataZ','Eh','Et');
            if ~isempty(get(0,'children'))
                if saveeps, saveas(gcf,[name '.eps'],'eps2c');end
                if savefig, saveas(gcf,[name '.fig'],'fig');end
            end;close
            
        case 'staircase potentio electrochemical impedance spectroscopy (mott-schottky)'
            [f, ~]  =dtextract(d,	  'freq');  f=d.table(:,f);
            [ReZ, ~]=dtextract(d,   'Re\(Z\)');  ReZ=  d.table(:,ReZ);
            [ImZ, ~]=dtextract(d,  '-Im\(Z\)');  ImZ= -d.table(:,ImZ);
            [AbZ, ~]=dtextract(d,     '\|Z\|');  AbZ=  d.table(:,AbZ);
            [PhZ, ~]=dtextract(d,'Phase\(Z\)');  PhZ=  d.table(:,PhZ);
            Eh=linspace(h.tec.Ei,h.tec.Ef,h.tec.N+1);Et={h.tec.vsEi h.tec.vsEf};
            fnum=ceil(log10(eng2num([num2str(h.tec.fi) h.tec.fiunits])/eng2num([num2str(h.tec.ff) h.tec.ffunits]))*double(h.tec.Nd));
            if fnum~=length(f)/(h.tec.N+1);
                newlength=fnum*floor(length(ReZ)/fnum);h.tec.N=newlength/fnum-1;
                f=f(1:newlength);ReZ=ReZ(1:newlength);ImZ=ImZ(1:newlength);AbZ=AbZ(1:newlength);PhZ=PhZ(1:newlength);
            end
            if min(h.tec.N,fnum-1)>0 && sum(reshape(f,fnum,h.tec.N+1)'/f(1:fnum)')/(h.tec.N+1)==1 %multi-step
                f=f(1:fnum);
                ReZ=reshape(ReZ,fnum,h.tec.N+1);ImZ=reshape(ImZ,fnum,h.tec.N+1);
                AbZ=reshape(AbZ,fnum,h.tec.N+1);PhZ=reshape(PhZ,fnum,h.tec.N+1);
                switch 3 %average or first value?
                    case 1
                        fprintf([' | ' 'Multiple steps. Using average.']);
                        ReZ=mean(ReZ,2);ImZ=mean(ImZ,2);
                        AbZ=mean(AbZ,2);PhZ=mean(PhZ,2);
                    case 2
                        fprintf([' | ' 'Multiple steps. Using first.']);
                        ReZ=mean(ReZ,2);ImZ=mean(ImZ,2);
                        AbZ=mean(AbZ,2);PhZ=mean(PhZ,2);
                    case 3
                        fprintf([' | ' 'Multiple steps. Using all.']);
                        beep;%keyboard
                end
            end
            
            try dataZ=plotZ_Bode(h,f,ReZ,ImZ,name);%
            catch exception;
                fprintf([' | ' 'plotZ_Bode FAILED: ' exception.identifier]); continue;
            end
            save(name,'h','d','f','ReZ','ImZ','AbZ','PhZ','dataZ','Eh','Et');
            if ~isempty(get(0,'children'))
                if saveeps, saveas(gcf,[name '.eps'],'eps2c');end
                if savefig, saveas(gcf,[name '.fig'],'fig');end
            end;close
            
        case 'chronoamperometry / chronocoulometry'
            [t, ~]   =dtextract(d,'time');   d.table=sortrows(d.table,t); t=d.table(:,t);
            %[P, d.Pu]=dtextract(d,'P');P=d.table(:,P);
            [V, d.Vu]=dtextract(d,'Ewe');V=d.table(:,V);
            [I, d.Iu]=dtextract(d,'I');I=d.table(:,I);
            
            save(name,'h','d','t','V','I');
            %[C R]=plotCA(h,t,V,I,name,1);if saveeps, saveas(gcf,[name '.eps'],'eps2c');end;
            %if savefig, saveas(gcf,[name '.fig'],'fig');end;close
    end
end
fprintf('\n');
%multiWaitbar([dirname ' :' num2str(size(directory,1)) ' files'],'Close');
end

function curves=cv_curves(cycle)
curves=[];
if isempty(diff(unique(cycle))) %single cycle?
    fprintf([' | ' 'cv_curves: single cycle?']);beep;
    curves=length(find(unique(cycle)));
else
    for jj=min(cycle):mode(diff(unique(cycle))):max(cycle)
        curves=[curves length(find(cycle==jj))];
    end
end
end