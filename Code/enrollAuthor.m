%enrollment code
%steps are:
%   1. Word segmentation
%   2. Feature extraction
%   3. Store feature template
%function enrollAuthor(imgSample, authorId, authorName, codeBook, authorDB, nameDB)
function authorDB=enrollAuthor(imgSample, authorId, codeBook, authorDB)
% if size(authorDB,1)~=size(nameDB,1)
%     error('AuthorDB and NameDb should have same number of rows');
% end
authorFeature=featureExtraction(imgSample,codeBook);
authorDB=[authorDB;[authorId,authorFeature]];
%nameDB(l)=[nameDB;[aut]]
%********each time enroll is called training is required if ELM is used ***
end