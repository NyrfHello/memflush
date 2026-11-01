# fish completion for memflush

complete -c memflush -s n -l no-notify -d "Terminal output only, skips desktop notification"
complete -c memflush -s s -l silent -d "Run completely silent (no terminal text or notification)"
complete -c memflush -s q -l quiet -d "Alias for --silent (ideal for autostart & cron)"
complete -c memflush -s v -l version -d "Display version information"
complete -c memflush -s h -l help -d "Show help message and usage"
