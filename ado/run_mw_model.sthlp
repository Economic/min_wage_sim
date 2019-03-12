{smcl}
{* 21dec2017}{...}
{hi:help run_mw_model}{...}
{right:Jump to: {help run_mw_model##syntax:Syntax}, {help run_mw_model##description:Description}, {help run_mw_model##options:Options}, {help run_mw_model##examples:Examples}, {help run_mw_model##remarks:Remarks}}
{right: Also see: {browse "http://economic.github.io/min_wage_sim"}}
{hline}

{title:Title}

{pstd}{hi:run_mw_model} {hline 2} Run EPI minimum wage simulation model

{marker syntax}{...}
{title:Syntax}

{pstd}
    Basic use:

{p 8 15 2}
    {cmd:run_mw_model}, {it:arguments}

{pstd}
    All of the arguments are required.

{synoptset 25 tabbed}{...}
{marker optiongrp1}{col 5}{help run_mw_model##optiongrp1:{it:optiongrp1}}{col 32}Description
{synoptline}
{synopt:{opt justanoption}}that does this.
    {p_end}
{synopt:{opt anotheroption}}doing something
    {p_end}
{synoptline}

{synoptset 25 tabbed}{...}
{marker optiongrp2}{col 5}{help run_mw_model##optiongrp2:{it:optiongrp2}}{col 32}Description
{synoptline}
{syntab :Subhead 1}
{synopt:{opt hello}}world
    {p_end}

{syntab :Subhead 2}
{synopt:{opt someoption}}something something
    {p_end}
{synopt:{opt someoption2}}something something2
    {p_end}

{marker description}{...}
{title:Description}

{pstd}
    {cmd:run_mw_model} a paragraph.

{pstd}
    Another paragraph.


{marker options}{...}
{title:Options}

    {help run_mw_model##optiongrp1:Options for group 1}
    {help run_mw_model##optiongrp2:Options for group 2}

{marker optiongrp1}{...}
{title:Options for group 1}

{phang}
    {opt outputdata} specifies the output data.

{phang}
    {opt intputdata} specifies the intput data.

{marker optiongrp2}{...}
{title:Options for group 2!}

{dlgtab:Main}

{phang}
    {opt something} a something.

{phang}
    {opt helloworld} something else.

{dlgtab:Log options}

{phang}
    {cmd:logoutput} for logging.


{marker examples}{...}
{title:Examples}

{pstd}
    A typical example:

        {com}. run_mw_model, argument(something)

{pstd}
    This will do the following.

{marker remarks}{...}
{title:Remarks}

{pstd}
    Some remarks.


{marker author}{...}
{title:Author}

{pstd}
    The authors.

{pstd}
    Please cite this as.

{pmore}
    Economic Policy Institute. 2019. Minimum wage simulation model.
