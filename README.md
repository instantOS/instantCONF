<div align="center">
    <h1>instantCONF</h1>
    <p>simple config system for instantOS</p>
    <img width="300" height="300" src="https://raw.githubusercontent.com/instantOS/instantLOGO/master/png/conf.png">
</div>

<p align="left">
<a href="https://www.buymeacoffee.com/paperbenni" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-blue.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>
</p>

# instantCONF

![Discord](https://img.shields.io/discord/683782260071071764)
![Maintenance](https://img.shields.io/maintenance/yes/2020)

instantCONF is a simple configuration system that doesn't require a settings daemon or anything fancy to run and can easily be scripted

## usage

Get the value of a setting option  
Prints the value to stdout. 
Exits with exit code 1 if the option is not set
´´´
iconf optionname
´´´

Set an option
´´´
iconf optionname value
´´´

binary options:

Get a binary option. doesn't print to stdout and instead exits with exit code 0 if option is true and 1 if the option is set to false. 
Defaults to false (exit status 1)
´´´
iconf -i optionname
´´´

set a binary option. 
```
iconf -i optionname 0/1
```

--------
## instantOS is still in early beta, contributions always welcome
