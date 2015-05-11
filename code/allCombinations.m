function combinations = allCombinations(sets)
    c = cell(1, numel(sets));
    [c{:}] = ndgrid( sets{:} );
    combinations = cell2mat( cellfun(@(v)v(:), c, 'UniformOutput',false) );
endfunction
