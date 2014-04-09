% **Put in config_EBUG around Line 103**

function [v,j,vTrained,vUntrained] = Army_counterbalances_432014(subnum)
% Sets Counterbalance (1-4). Divides subject number by 3 and then rounds answer up to nearest integer. To allow for more
% than 12 subjects, divides the integer by 4 and finds the remainder. The -1 and +1 take into account the way that
% Matlab creates indices.    
counterbalance = mod(ceil(subnum/3)-1,4)+1;

% Sets the Difficulty (1-3). Subtracts 1 from the subject number, divides this value by 3 and finds the remainder.
% The +1 takes into account the way that Matlab creates indices. 
difficulty = mod(subnum-1,3)+1;
nFamilies = 2; %number of families
nSpecies = 10; %total number of species
nNew = 2; %number of new species
nExemplars = 12; %number of exemplars per species
nTrained = (nSpecies-nNew-1)*(nSpecies-nNew); %the number of trained (and untrained) pairs (n+n-1+n-2+...+2+1 = n*(n+1)/2; 2 species)
totExemplars = nFamilies*nExemplars*nSpecies; %the total number of exemplars in the experiment
% Counterbalance is now just referring to which species are skipped
exemplars = randperm(nExemplars,nExemplars); %randomize exemplar order
tExemplars = exemplars(1:6); %trained examplers come from the first half
uExemplars = exemplars(7:12); %untrained exemplars come from the second half
if counterbalance == 1 %counterbalance 1 skips species 5,10
	skips = [5,10]; 
elseif counterbalance == 2 %counterbalance 2 skips species 1,3
	skips = [1,3];
elseif counterbalance == 3
	skips = [4,2];
elseif counterbalance == 4
	skips = [6,9];
end

if difficulty == 1 %Difficulty condition 1 goes from easiest to hardest
	v1 = load('DifficultyConditions.txt');
    [~, ord] = sort(v1(:,4),'ascend');
    v = zeros(size(v1));
    v(:,1) = v1(ord,1);
    v(:,2) = v1(ord,2);
    v(:,3) = v1(ord,3);
    v(:,4) = v1(ord,4);
elseif difficulty == 2 %goes from hardest to easiest
	v1 = load('DifficultyConditions.txt');
    [~, ord] = sort(v1(:,4),'descend');
    v = zeros(size(v1));
    v(:,1) = v1(ord,1);
    v(:,2) = v1(ord,2);
    v(:,3) = v1(ord,3);
    v(:,4) = v1(ord,4);
elseif difficulty == 3 %goes in a totally random order
	v1 = load('DifficultyConditions.txt');
	ord = randperm(size(v1,1));
    v = zeros(size(v1));
    v(:,1) = v1(ord,1);
    v(:,2) = v1(ord,2);
    v(:,3) = v1(ord,3);
    v(:,4) = v1(ord,4);
end

% Within Spec Pairs
if difficulty == 1 %Difficulty condition 1 goes from easiest to hardest
	v2 = load('WithinSpecRate.txt');
    [~, ord] = sort(v2(:,4),'ascend');
    vv = zeros(size(v2));
    vv(:,1) = v2(ord,1);
    vv(:,2) = v2(ord,2);
    vv(:,3) = v2(ord,3);
    vv(:,4) = v2(ord,4);
elseif difficulty == 2 %goes from hardest to easiest
	v2 = load('WithinSpecRate.txt');
    [~, ord] = sort(v2(:,4),'descend');
    vv = zeros(size(v2));
    vv(:,1) = v2(ord,1);
    vv(:,2) = v2(ord,2);
    vv(:,3) = v2(ord,3);
    vv(:,4) = v2(ord,4);
elseif difficulty == 3 %goes in a totally random order
	v2 = load('WithinSpecRate.txt');
	ord = randperm(size(v2,1));
    vv = zeros(size(v2));
    vv(:,1) = v2(ord,1);
    vv(:,2) = v2(ord,2);
    vv(:,3) = v2(ord,3);
    vv(:,4) = v2(ord,4);
end

fam_str = 'as';
spec_str = 'abcdefghij';

count = 1;
%create arrays for untrained and trained species pairs
vTrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
vUntrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
for j = 1:size(v,1)
	if v(j,2) ~= skips(1) && v(j,2) ~= skips(2) && v(j,3) ~= skips(1) && v(j,3) ~= skips(2)
        vTrained(count,:) = [v(j,1),v(j,2),tExemplars(randsample(1:6,1)),v(j,3),tExemplars(randsample(1:6,1))];
        vUntrained(count,:) = [v(j,1),v(j,2),uExemplars(randsample(1:6,1)),v(j,3),uExemplars(randsample(1:6,1))];
        fprintf('%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vTrained(count,1)),spec_str(vTrained(count,2)),vTrained(count,3),spec_str(vTrained(count,4)),vTrained(count,5),fam_str(vTrained(count,1)),spec_str(vTrained(count,2)),vTrained(count,3),fam_str(vTrained(count,1)),spec_str(vTrained(count,4)),vTrained(count,5));
        fprintf('%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vUntrained(count,1)),spec_str(vUntrained(count,2)),vUntrained(count,3),spec_str(vUntrained(count,4)),vUntrained(count,5),fam_str(vUntrained(count,1)),spec_str(vUntrained(count,2)),vUntrained(count,3),fam_str(vUntrained(count,1)),spec_str(vUntrained(count,4)),vUntrained(count,5))
        count = count+1;
	end
end
% Within Spec Pairs
count = 1;
%create arrays for untrained and trained species pairs
vvTrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
vvUntrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
for j = 1:size(vv,1)
	if vv(j,2) ~= skips(1) && vv(j,2) ~= skips(2) && vv(j,3) ~= skips(1) && vv(j,3) ~= skips(2)
        vvTrained(count,:) = [vv(j,1),vv(j,2),tExemplars(randsample(1:6,1)),vv(j,3),tExemplars(randsample(1:6,1))];
        vvUntrained(count,:) = [vv(j,1),vv(j,2),uExemplars(randsample(1:6,1)),vv(j,3),uExemplars(randsample(1:6,1))];
        fprintf('%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vvTrained(count,1)),spec_str(vvTrained(count,2)),vvTrained(count,3),spec_str(vvTrained(count,4)),vvTrained(count,5),fam_str(vvTrained(count,1)),spec_str(vvTrained(count,2)),vvTrained(count,3),fam_str(vvTrained(count,1)),spec_str(vvTrained(count,4)),vvTrained(count,5));
        fprintf('%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vvUntrained(count,1)),spec_str(vvUntrained(count,2)),vvUntrained(count,3),spec_str(vvUntrained(count,4)),vvUntrained(count,5),fam_str(vvUntrained(count,1)),spec_str(vvUntrained(count,2)),vvUntrained(count,3),fam_str(vvUntrained(count,1)),spec_str(vvUntrained(count,4)),vvUntrained(count,5))
        count = count+1;
	end
end

makedir = sprintf('%s%d%s','participant',subnum,'.txt');
fid1=fopen(makedir, 'a+');
count = 1;
%create arrays for untrained and trained species pairs
vTrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
vUntrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
for j = 1:size(v,1)
	if v(j,2) ~= skips(1) && v(j,2) ~= skips(2) && v(j,3) ~= skips(1) && v(j,3) ~= skips(2)
        vTrained(count,:) = [v(j,1),v(j,2),tExemplars(randsample(1:6,1)),v(j,3),tExemplars(randsample(1:6,1))];
        vUntrained(count,:) = [v(j,1),v(j,2),uExemplars(randsample(1:6,1)),v(j,3),uExemplars(randsample(1:6,1))];
        fprintf(fid1,'%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vTrained(count,1)),spec_str(vTrained(count,2)),vTrained(count,3),spec_str(vTrained(count,4)),vTrained(count,5),fam_str(vTrained(count,1)),spec_str(vTrained(count,2)),vTrained(count,3),fam_str(vTrained(count,1)),spec_str(vTrained(count,4)),vTrained(count,5));
        fprintf(fid1,'%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vUntrained(count,1)),spec_str(vUntrained(count,2)),vUntrained(count,3),spec_str(vUntrained(count,4)),vUntrained(count,5),fam_str(vUntrained(count,1)),spec_str(vUntrained(count,2)),vUntrained(count,3),fam_str(vUntrained(count,1)),spec_str(vUntrained(count,4)),vUntrained(count,5));
        count = count+1;
	end
end
%Within Spec Pairs
count = 1;
%create arrays for untrained and trained species pairs
vvTrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
vvUntrained = zeros(nTrained,5); %format: Family | Species1 | Exemplar1 | Species2 | Exemplar2
for j = 1:size(vv,1)
	if vv(j,2) ~= skips(1) && vv(j,2) ~= skips(2) && vv(j,3) ~= skips(1) && vv(j,3) ~= skips(2)
        vvTrained(count,:) = [vv(j,1),vv(j,2),tExemplars(randsample(1:6,1)),vv(j,3),tExemplars(randsample(1:6,1))];
        vvUntrained(count,:) = [vv(j,1),vv(j,2),uExemplars(randsample(1:6,1)),vv(j,3),uExemplars(randsample(1:6,1))];
        fprintf(fid1,'%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vvTrained(count,1)),spec_str(vvTrained(count,2)),vvTrained(count,3),spec_str(vvTrained(count,4)),vvTrained(count,5),fam_str(vvTrained(count,1)),spec_str(vvTrained(count,2)),vvTrained(count,3),fam_str(vvTrained(count,1)),spec_str(vvTrained(count,4)),vvTrained(count,5));
        fprintf(fid1,'%s\t%s\t%d\t%s\t%d\t%s%s%d.bmp\t%s%s%d.bmp\n', fam_str(vvUntrained(count,1)),spec_str(vvUntrained(count,2)),vvUntrained(count,3),spec_str(vvUntrained(count,4)),vvUntrained(count,5),fam_str(vvUntrained(count,1)),spec_str(vvUntrained(count,2)),vvUntrained(count,3),fam_str(vvUntrained(count,1)),spec_str(vvUntrained(count,4)),vvUntrained(count,5))
        count = count+1;
	end
end




stimList = zeros(totExemplars,5); %format: Family | Species | Exemplar | TrainedSpecies | TrainedExemplar
for j = 1:totExemplars
    %family = ceil(j/120)? %1 up to 120, 2 after 120
    %species = mod(ceil(j/12)-1,10)+1? %1 for 1-12, 2 for 13-24, 3 for 25-36...
    %exemplar = mod(j,12)?
    %stimlist(j,:) = [family, species, exemplar, 0, 0];
    %%%is family, species, exemplar trained%%%
    %if not in skips species TrainedSpecies = 1
        %if in tExemplars TrainedExemplars = 1
        %else TrainedExemplars = 0
    %else 0
end
