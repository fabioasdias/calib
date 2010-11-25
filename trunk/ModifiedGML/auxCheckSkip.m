function skip=auxCheckSkip(vidName,number)
if (exist([vidName '.sk'],'file')~=0)
    frames=textread([vidName '.sk']);
    skip=any(frames==number);
else
    skip=0;
end
end
