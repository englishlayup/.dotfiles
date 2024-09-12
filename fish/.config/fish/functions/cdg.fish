function cdg -d "cd relative to git root"
    cd (git rev-parse --show-toplevel 2>/dev/null)/$argv[1]
end
