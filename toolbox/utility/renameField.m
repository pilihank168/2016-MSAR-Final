function outStruct=renameField(inStruct, oldField, newField)

outStruct=inStruct;
if isfield(inStruct, oldField)
	[inStruct.(newField)]=inStruct.(oldField);
	outStruct = rmfield(inStruct, oldField);
end