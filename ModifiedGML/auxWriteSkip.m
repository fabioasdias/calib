function auxWriteSkip(vidName,number)
    if (exist([vidName '.cur'],'file')~=0)
        ban=textread([vidName '.cur']);
        flist=fopen([vidName '.sk'],'a');
        fprintf(flist,'%d\n',ban);
        fclose(flist);
    end
    fcur=fopen([vidName '.cur'],'w');
    fprintf(fcur,'%d\n',number);
    fclose(fcur);
end