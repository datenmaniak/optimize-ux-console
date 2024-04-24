#!/bin/bash

#
#  Activa el prompt basado en 'powerline'
#


set_prompt() {
    # Powerline prompt

    prompt_enable="false"
    #echo -e " - Enable Powerline Prompt here"

    detect_os
    if [ "$OS_DERIVATES" == 'deb' ] ; then
            if [ -f  "/usr/share/powerline/bindings/bash/powerline.sh" ]; then
                source /usr/share/powerline/bindings/bash/powerline.sh
                prompt_enable="true"
            else
                prompt_enable="false"
            fi
    elif [ "$OS_DERIVATES" == 'rpm' ] ; then
            #TODO: 
            echo "Pendiente  para rpm pkgages"
            source /usr/share/powerline/bash/powerline.sh
            prompt_enable="true"
    else 
         echo " - Check package installer for this platform: $1"
         prompt_enable="false"
    fi
    
    # case $os_result in
    #     "rpm")
    #         # echo -e "$msg $RPM_TYPE"
    #         source /usr/share/powerline/bash/powerline.sh
    #         prompt_enable="true"
    #     ;;
    #     "deb")
    #         # echo -e "$msg $DEB_TYPE"
            
    #         if [ -f  "/usr/share/powerline/bindings/bash/powerline.sh" ]; then
    #             source /usr/share/powerline/bindings/bash/powerline.sh
    #             prompt_enable="true"
    #         else
    #             prompt_enable="false"
    #         fi
    #     ;;
    #     *)
    #         echo -e "\nOperating system not compatible with .rpm / .deb"
    #     ;;
    # esac
    
    if [  $prompt_enable == "false" ]; then
        echo -e "\tThere was no success enabling the prompt "
    fi
    
}

install_according_distro() {

        detect_os

        echo -e " - Install powerline for \"$OS_DERIVATES\" derivatives systems "

        if [ $OS_DERIVATES == "rpm" ]; then
            install_package powerline powerline-fonts  # install powerline for Fedora
            #install_package powerline-fonts
        fi
        if [ $OS_DERIVATES == "deb" ]; then
            install_package powerline fonts-powerline # install powerline for Debian
            #install_package fonts-powerline # install powerline for Debian
        fi

        # enable_powerline
        # if [ $installed ] ; then
        #  echo -e " *** INSTALLED **"
        # fi
}

enable_powerline_prompt() {


    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    
    
}

confirm_installation() {
    PS3="Select the choice, please: "

    items=("Install the package" )
    pkg="hello"

    while true; do
        select item in "${items[@]}" "Continue"
        do
            case $REPLY in                                                                       
                1)                                                                               
                   echo -e "\t - Selected item #$REPLY which means $item $pkg"                           
                   return 1                                                                         
                   ;;                                                                            
                $((${#items[@]}+1)))                                                             
                   echo "We're done!"                                                            
                   break 2                                                                       
                   ;;                                                                            
                *) echo "Ooops - unknown choice $REPLY"                                          
                break;;                                                                          
            esac                                                                                 
        done                                                                                     
    done                                                                                         
                                                                                                 
}



prompt_main_startup () {
    
    pkg_query powerline
    if [  $? -eq 0 ] && [  "$pkg_found" == 0 ]; then
        
        ##  Give user options 
        confirm_installation
        if [ $? -eq 1 ] ; then
            # Accepted
            
            install_according_distro
            

        # else 
        # echo -e "** INSTALL POWERLINE if $installed = 1"
        #     echo -e "** Continue: $?"
        fi
        
    fi
}


customize_shell_prompt() {
    echo -e " - Customize the bash shell"
    prompt_main_startup
    if [ "$pkg_found" == 1 ] ; then
        enable_powerline_prompt
        set_prompt
    fi
    
}