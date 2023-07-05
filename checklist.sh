#!/bin/bash


RED='\033[0;31m'
Green='\033[0;32m'
NC='\033[0m' # No Color
rm temp.txt
touch temp.txt

##########################

echo "CHECK 1"
echo "Checking whether TUNED service is active or not. No output means service is not there."
echo
output=`systemctl status tuned.service | grep -w active`
enable=`systemctl status tuned.service | grep -w enabled`
if [[ ! -z $output ]] ; then
            echo "Tuned service is enabled: "
            echo  "$output $enable"
else
        echo -e "${RED}Tuned service is inactive,${NC} please enable/check${NC}" >> temp.txt
fi
echo

###########################

echo "CHECK 2"
echo "Checking output of tuned-adm active. No output means service is not there."
echo
tuned_adm=`sudo tuned-adm active | grep network-latency`

if [[ ! -z $tuned_adm ]] ; then
            echo "Output of tuned-adm active is :"
            echo " $tuned_adm"
else
echo -e "${RED}tuned-adm is not active,${NC} activate network-latency profile in adm" >> temp.txt
    fi
echo

###########################
echo "CHECK 3"

echo
echo "Max-clock frequency and current clock frequency should be same"
echo
echo `lscpu | grep "CPU MHz"`
echo `lscpu | grep "CPU max MHz"`
echo

#############################
echo "CHECK 4"

echo
echo "/data dir should point to /mnt/data"
ls -ltr /data | grep /mnt/data
if [ $? -ne 0 ] ; then
echo -e "${RED}/data is not pointing to /mnt/data,${NC}  please verify ls -ltr /data${NC}" >> temp.txt
fi

############################
echo "CHECK 5"
echo
echo "changing ownership of trading folder"
echo
sudo chown -R trading:users /home/trading/
ls -ltra /home/trading | grep -v '\.\.' | grep -v \.bash_profile | grep -v total | awk {'print $3'} | grep -v trading
if [ $? -eq 0 ] ; then
echo -e "${RED}/home/trading folder ownership error,${NC} please check ls -ltra /home/trading${NC}" >> temp.txt
fi

###############################
echo "CHECK 6"
echo
echo "Onload version check"
echo `onload --version`
echo
####################################
echo "CHECK 7"
echo
echo "loader.conf file should have Linux LTS as default"
cat /boot/loader/loader.conf | grep lts | grep default
if [ $? -ne 0 ] ; then
echo -e "${RED}loader.conf do not have Linux LTS as default,${NC} please check and fix" >> temp.txt
fi

#####################################
echo "CHECK 8"
echo
echo "Adding keys in authorized keys of trading user"
cat << EOF > /home/trading/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChgcQxc2X3jjvfYNsxZtUnQn0VUiBL3KIUB1T88jaITG1/CkAOmb9Uv8RRItdUVH0ufcoeAy3S6dXK+NKnTwjX4uIfB5KeAs/rw3ngm8VhBumusQGZOyXdx2WQP7Qw5bkx1B5xR09t3LJNRW+juqBMcXxn8vDt1LMJFLXuOyaKX/p93jqjQz4S1AREBxl/24j7bgqJN2tkojbhEp8CYQIf4zBKzPGYj9TFqSkSD5sbzClUoiA+W6HsopbxKByzcz9ctJ/Ra+QGdQBGSMs5Pe5H/g8+SUW2aoYJNyJNG+Askg0PGS2G59BDyzA/iQTHfHywJZ+heUtCO0lcHG3lh04UqXMj4jUB0Vl3yhHkhsDdaAQvgRUjf8sE2qHb0Ux4kF6574NnplG++ZNTf7uQCKDB3tLGO2WdrtDhsTNvvjAtKlK1t/UB8gUO3XOlSQ9kQgti1SO2BoD03YMOhrE5ykBjBkp6ztVt28KovsFoeGBZY9P8iDdBkNrcUfloFzMHGvL9Bn3yzPaRebxS7vN2Gl79ZdMIoN4FC7ggP4oPF6o60hjj5FJ8IjVSXd1dNs4AExz13o+1PqwAIhIKoUNVQHcCV37HQIAlMe7UMfEbyvJNbp0Z/q46wwbWXjywPJ4+fNJ00XFupFsT6/XIg0ddxAlD6RtbTOkmVFsgW7FitvDwoQ== nishil.gupta@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkpig6RsxdiBQhw6ByOdxJVgS+I6YFTGA6ZOYI/dBxOrG489bkWkpF3ceSi7ycN5k7CIqPWjZ0mepSWoH+tOE+ZXeIw6LAWpBDvVrDqvQ33ANAzX2LskGBPR5RvehaJlODdAKdLnTciXrX5tPBXdIfeDxCVd4cql8HMstK6lXzwp8JtkUVrY5pPrB/ZKGAug7irPpC+D90/fVc5dtTviUnsNvG83a7T9gheOSCvnvXFmHaYtOZenISsfxziufeC8NHLRf1LWqJX34x+JsGXS4fpHurjXvRt21FV92DiF3iHOJ6t8WBmb5DQ6WO1e2H0STpPGWxd60T+44U5Iv/IpQu3nVna3D08A+aQ9sWmlxAFe5pkDVhW0nv6tnNJVbBTqvhnpkhVwivQ7Ft/5Kghn4SDL9hs17Ujjc2+DQWuYGSifugpeWFnX0xD3pLqkiTB77+ejckiIj7XJGIXY3XYT/GLJOQVqnMRbsqsPDmQH7AEzoN/ACfF8kcQp6ul4S53byBXR/A6npFDcOTyc3XC0uuJcyPUWJYVs3UUHErnVDbJiaUbOUSXadYPgoz9cq1UZ0pJOfKnOPDG+7drJrF3pwm83Lecq+h9mQgqn1cXk3kDG4wvhN2Qg54PVviWTVMQdjEn1guwKFuX+zWkjmpZwcAQCqFtXAM2T9H+wZD5+vY5Q== ankit.gupta@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgFVtJ2aRI+VQwbzh/Lkj2SnfbRmNxtBJSSc6cUH0Hsz5bvsCAFJUPxppQREEAxVncjW9jWerq/7zCXJ/I9szYwFYX+7aWVFHizzRcbtOMsfaJUmcSYXY23qO1qycYmM6dWuhSpn7J1+ofN6RKiDX4mWvBOtJCUV9/V64SC1nSX5UTr5TAXAqLqzN1zkzVllF7ZPaT+ZGqCO4bAEOQUa770+7gOONpe+zYcXkZy3IoL3GZPQSEZpb5hFsU1gXQjto0qruzuC1u7rzTzsdP6cyoN66zOTZ2qQlugh6fX7CjNA1fi2RtnobfbVsST7nn4L/7RmOno9tlcVF6DZhwfjL9WR+zyaads1ULifyV2VNPAGEI25zB388CMMnFuvgVGHCYhtWYV9Wk4cH9GTkjokLI0wb9IOgw2XhTrTRIh0Jth5OGNibqrcoyMLcY6R18D44+wqtcP232Vmqj+e1l6ZcZuYefnqTWtLN2NwxkqIm90zwMcd+8vIQQlojUNo75d8+NrpU5rgAv/9AfOqj3xKj/iBylQMkSvSxexVRvwcyCyLraDWQdFQ5N1rn1M2FwzcHZuMEMZCqmFbPKBm5WyWxIOd0pVf0C0hklGNvheRL+n7UMcXgQMCMCh6Bcn2Qg9sKK0h2FeyhAbKQux+nftc8KA3EwIi2MHE4LsqSBno90Uw== naina.gupta@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0Fjw9qyijwpsGAyWIpBI1Bjjy2fKeOrr9bGMnGNVhcZWFvsWMvgRfmVh5TLyZ/qVOb6xfyca/hBYmUqTgKvclLmZWyXkwodHRtXsjwKB/vCSHacOnKwtfvkYdMyJbrDAa8Sx7NpzvJE8im6bjtkGCDd20yvmsxQRvP/nGvovCrpIsrIjsvrlyhfWadYlvL+98Rywvmb6om9w713VWVBXYbNWshvODFFcPJ5AvvnxORt91UGMprF/wUtzQgVuUzIinvZcTWvYeYTJX0UuqbWPqVCx/pq9ZDSxTnp2WPe6ApfmClkhIIppQN7GSwT5JJeX4iFnciq/EQWDXMVe+xa3mVE9M+MTBGb/o+SuIAyYmBgCfSQkkRgn24nIEpihlZkrsKP4AkKPf6MjJoOZxmO7WLjgbmZYAW4P6B5NNL3en0XtWLRBRlUew44S/I3VovrZE2gGbe91q129f51ah+j1ynJDsGxIFlaf93XsZgS6lmK7TEEcS/qSd16Ny073YgArMMgICsp0+IqUiETRwdTcdajQdVIMNaFYMx2FexkWryCEiJ/ZJx0TC3lF3lirx5KtY4Qee2PufrArN3XEJ7MOVA31d2vD/t/mTKbJTVSaxWn/aPGlNiYKWssGMxWmkP1GU7bUJmyvwP76CyYeKHADpMxdWrbRFunggbWCRgmH5zw== rituka.sharma@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO21k37Igovme4kWfzwAHzGXVqexrPOvNuz3K6dKzXmQExod6bCPonuy6+HHZAVnnb86/x7Zphg0ZKizyg95gRnxsY7jp95HUnPTfYYGouLIiQkyOFBZq0zptQvoTL/AtfoaVOfvUaSogd6pj4pgepp+CgnQNnyaMzupB2lUpYRabu5/A7nrLeYEMDYMTRY9rW5m/67ny9YaZZrsxslHqSBmzsAlqPJUQDthdcSJb18EtYNwj5VMBbQJsFjWBVs0MnjFT0q+KF2rOb0LHULs7WF8qQKJdCaFDyO7gKtQkyfnsjg5ybqo1svttW8g+m31uiA02Gys7HUDK7MF85hCKtrHZiIbO1xiLIhB3snC6zBzgVwR5HhvcXHQuFOVDyg8vUR6r1TEewGKRs3F67FxzaWObYp5l0b1Q6kZnfyHlzXX9ut8R0LLH4LVbolpxgX+TDJ1awtQHWvro2drUt51JY6rcz1klFgCA/cjzxVwspUdsUH+xvQV7ovBXe2ub7bAJGEd5YHbzh1uHQjDWPXHHqv6r9b4B1bUpBaphyH5WN2s2QUYn8xkYi+iZoNs5r6Ds1QOgAwm6AJxj4m85BKWoYO+7LKzTB9ak2Trs2078rMKG7pDhCwfzXp8uclOyVYRC2yVr2h7MQulLuM0UWUoSuz+FntWU89fpWYhOu2FX18w== girik.pachauri@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8zUnoa8rKw86RxVUZl5gbo5UVY0PnFDxMfC45/+1mV27iQFb+yWM7aA/i6IT3iYRZ2rxjl+ydPy0NrLu9WApUpZToHOuAPUPGDgipbfU9sX+XppjBAIglSKgQVQeN/CAym+ZWDq/5XaZZ/qCrkhGWIvG+w7GfwruEx3GlpWcm37bOpaRSB59NreibhEVS6wAg2bmtzphY+2vNetJsn8yt1mKdRN1VoL43CWNekhg01wsOPbHNhGbnt0SPD+qmy97q+QFbU+QDop+3BRwJflycyR1tkIVKH7/TPOGjUGtEAXV4xQTsD+pTflBrS9/91evvYRbYOj15SE9hc/hvC5HC0Qj7IErxO17NBzknK7OwSj/JHTBb7qbTwOGDwo+inrLt2id4SGFW8vPJEu5iDTy3XQgOCyw6rSR+bT14r2LsXagbm1vVAq/0I39XqR+IsQWwA54PjGWS2O9U4REmo6PzUmb117wv5eo3X28pqclabREDW7pPHkTrpJUlqgUIInYrnEbXIcOYRfo7Uic6+go7t+GjDJwkF79SRiCE9J2Eg2Vjwpfz9lGSL9iAoNDyZ5esomS9z4gPB+OMXNwgB/3YVnIeeFGXS7tJJ2bme2hF6i2pbE6fdBL2THwUErTn3nfZok129wAEKl3ogWWCJj7EUGI8O90puxURVsxjxijEDQ== icinga@gravitontrading.com

EOF

echo
echo "Verifying content of authorized_keys"
echo
cat /home/trading/.ssh/authorized_keys
if [ $? -ne 0 ] ; then
echo -e "${RED}/home/trading/.ssh/authorized_keys file not present,${NC} please check and fix" >> temp.txt
fi

####################################
echo "CHECK 9"
echo
echo "Adding keys in authorized keys of root user"
cat << EOF > /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkpig6RsxdiBQhw6ByOdxJVgS+I6YFTGA6ZOYI/dBxOrG489bkWkpF3ceSi7ycN5k7CIqPWjZ0mepSWoH+tOE+ZXeIw6LAWpBDvVrDqvQ33ANAzX2LskGBPR5RvehaJlODdAKdLnTciXrX5tPBXdIfeDxCVd4cql8HMstK6lXzwp8JtkUVrY5pPrB/ZKGAug7irPpC+D90/fVc5dtTviUnsNvG83a7T9gheOSCvnvXFmHaYtOZenISsfxziufeC8NHLRf1LWqJX34x+JsGXS4fpHurjXvRt21FV92DiF3iHOJ6t8WBmb5DQ6WO1e2H0STpPGWxd60T+44U5Iv/IpQu3nVna3D08A+aQ9sWmlxAFe5pkDVhW0nv6tnNJVbBTqvhnpkhVwivQ7Ft/5Kghn4SDL9hs17Ujjc2+DQWuYGSifugpeWFnX0xD3pLqkiTB77+ejckiIj7XJGIXY3XYT/GLJOQVqnMRbsqsPDmQH7AEzoN/ACfF8kcQp6ul4S53byBXR/A6npFDcOTyc3XC0uuJcyPUWJYVs3UUHErnVDbJiaUbOUSXadYPgoz9cq1UZ0pJOfKnOPDG+7drJrF3pwm83Lecq+h9mQgqn1cXk3kDG4wvhN2Qg54PVviWTVMQdjEn1guwKFuX+zWkjmpZwcAQCqFtXAM2T9H+wZD5+vY5Q== ankit.gupta@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQChgcQxc2X3jjvfYNsxZtUnQn0VUiBL3KIUB1T88jaITG1/CkAOmb9Uv8RRItdUVH0ufcoeAy3S6dXK+NKnTwjX4uIfB5KeAs/rw3ngm8VhBumusQGZOyXdx2WQP7Qw5bkx1B5xR09t3LJNRW+juqBMcXxn8vDt1LMJFLXuOyaKX/p93jqjQz4S1AREBxl/24j7bgqJN2tkojbhEp8CYQIf4zBKzPGYj9TFqSkSD5sbzClUoiA+W6HsopbxKByzcz9ctJ/Ra+QGdQBGSMs5Pe5H/g8+SUW2aoYJNyJNG+Askg0PGS2G59BDyzA/iQTHfHywJZ+heUtCO0lcHG3lh04UqXMj4jUB0Vl3yhHkhsDdaAQvgRUjf8sE2qHb0Ux4kF6574NnplG++ZNTf7uQCKDB3tLGO2WdrtDhsTNvvjAtKlK1t/UB8gUO3XOlSQ9kQgti1SO2BoD03YMOhrE5ykBjBkp6ztVt28KovsFoeGBZY9P8iDdBkNrcUfloFzMHGvL9Bn3yzPaRebxS7vN2Gl79ZdMIoN4FC7ggP4oPF6o60hjj5FJ8IjVSXd1dNs4AExz13o+1PqwAIhIKoUNVQHcCV37HQIAlMe7UMfEbyvJNbp0Z/q46wwbWXjywPJ4+fNJ00XFupFsT6/XIg0ddxAlD6RtbTOkmVFsgW7FitvDwoQ== nishil.gupta@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDgFVtJ2aRI+VQwbzh/Lkj2SnfbRmNxtBJSSc6cUH0Hsz5bvsCAFJUPxppQREEAxVncjW9jWerq/7zCXJ/I9szYwFYX+7aWVFHizzRcbtOMsfaJUmcSYXY23qO1qycYmM6dWuhSpn7J1+ofN6RKiDX4mWvBOtJCUV9/V64SC1nSX5UTr5TAXAqLqzN1zkzVllF7ZPaT+ZGqCO4bAEOQUa770+7gOONpe+zYcXkZy3IoL3GZPQSEZpb5hFsU1gXQjto0qruzuC1u7rzTzsdP6cyoN66zOTZ2qQlugh6fX7CjNA1fi2RtnobfbVsST7nn4L/7RmOno9tlcVF6DZhwfjL9WR+zyaads1ULifyV2VNPAGEI25zB388CMMnFuvgVGHCYhtWYV9Wk4cH9GTkjokLI0wb9IOgw2XhTrTRIh0Jth5OGNibqrcoyMLcY6R18D44+wqtcP232Vmqj+e1l6ZcZuYefnqTWtLN2NwxkqIm90zwMcd+8vIQQlojUNo75d8+NrpU5rgAv/9AfOqj3xKj/iBylQMkSvSxexVRvwcyCyLraDWQdFQ5N1rn1M2FwzcHZuMEMZCqmFbPKBm5WyWxIOd0pVf0C0hklGNvheRL+n7UMcXgQMCMCh6Bcn2Qg9sKK0h2FeyhAbKQux+nftc8KA3EwIi2MHE4LsqSBno90Uw== naina.gupta@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0Fjw9qyijwpsGAyWIpBI1Bjjy2fKeOrr9bGMnGNVhcZWFvsWMvgRfmVh5TLyZ/qVOb6xfyca/hBYmUqTgKvclLmZWyXkwodHRtXsjwKB/vCSHacOnKwtfvkYdMyJbrDAa8Sx7NpzvJE8im6bjtkGCDd20yvmsxQRvP/nGvovCrpIsrIjsvrlyhfWadYlvL+98Rywvmb6om9w713VWVBXYbNWshvODFFcPJ5AvvnxORt91UGMprF/wUtzQgVuUzIinvZcTWvYeYTJX0UuqbWPqVCx/pq9ZDSxTnp2WPe6ApfmClkhIIppQN7GSwT5JJeX4iFnciq/EQWDXMVe+xa3mVE9M+MTBGb/o+SuIAyYmBgCfSQkkRgn24nIEpihlZkrsKP4AkKPf6MjJoOZxmO7WLjgbmZYAW4P6B5NNL3en0XtWLRBRlUew44S/I3VovrZE2gGbe91q129f51ah+j1ynJDsGxIFlaf93XsZgS6lmK7TEEcS/qSd16Ny073YgArMMgICsp0+IqUiETRwdTcdajQdVIMNaFYMx2FexkWryCEiJ/ZJx0TC3lF3lirx5KtY4Qee2PufrArN3XEJ7MOVA31d2vD/t/mTKbJTVSaxWn/aPGlNiYKWssGMxWmkP1GU7bUJmyvwP76CyYeKHADpMxdWrbRFunggbWCRgmH5zw== rituka.sharma@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDO21k37Igovme4kWfzwAHzGXVqexrPOvNuz3K6dKzXmQExod6bCPonuy6+HHZAVnnb86/x7Zphg0ZKizyg95gRnxsY7jp95HUnPTfYYGouLIiQkyOFBZq0zptQvoTL/AtfoaVOfvUaSogd6pj4pgepp+CgnQNnyaMzupB2lUpYRabu5/A7nrLeYEMDYMTRY9rW5m/67ny9YaZZrsxslHqSBmzsAlqPJUQDthdcSJb18EtYNwj5VMBbQJsFjWBVs0MnjFT0q+KF2rOb0LHULs7WF8qQKJdCaFDyO7gKtQkyfnsjg5ybqo1svttW8g+m31uiA02Gys7HUDK7MF85hCKtrHZiIbO1xiLIhB3snC6zBzgVwR5HhvcXHQuFOVDyg8vUR6r1TEewGKRs3F67FxzaWObYp5l0b1Q6kZnfyHlzXX9ut8R0LLH4LVbolpxgX+TDJ1awtQHWvro2drUt51JY6rcz1klFgCA/cjzxVwspUdsUH+xvQV7ovBXe2ub7bAJGEd5YHbzh1uHQjDWPXHHqv6r9b4B1bUpBaphyH5WN2s2QUYn8xkYi+iZoNs5r6Ds1QOgAwm6AJxj4m85BKWoYO+7LKzTB9ak2Trs2078rMKG7pDhCwfzXp8uclOyVYRC2yVr2h7MQulLuM0UWUoSuz+FntWU89fpWYhOu2FX18w== girik.pachauri@gravitontrading.com
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8zUnoa8rKw86RxVUZl5gbo5UVY0PnFDxMfC45/+1mV27iQFb+yWM7aA/i6IT3iYRZ2rxjl+ydPy0NrLu9WApUpZToHOuAPUPGDgipbfU9sX+XppjBAIglSKgQVQeN/CAym+ZWDq/5XaZZ/qCrkhGWIvG+w7GfwruEx3GlpWcm37bOpaRSB59NreibhEVS6wAg2bmtzphY+2vNetJsn8yt1mKdRN1VoL43CWNekhg01wsOPbHNhGbnt0SPD+qmy97q+QFbU+QDop+3BRwJflycyR1tkIVKH7/TPOGjUGtEAXV4xQTsD+pTflBrS9/91evvYRbYOj15SE9hc/hvC5HC0Qj7IErxO17NBzknK7OwSj/JHTBb7qbTwOGDwo+inrLt2id4SGFW8vPJEu5iDTy3XQgOCyw6rSR+bT14r2LsXagbm1vVAq/0I39XqR+IsQWwA54PjGWS2O9U4REmo6PzUmb117wv5eo3X28pqclabREDW7pPHkTrpJUlqgUIInYrnEbXIcOYRfo7Uic6+go7t+GjDJwkF79SRiCE9J2Eg2Vjwpfz9lGSL9iAoNDyZ5esomS9z4gPB+OMXNwgB/3YVnIeeFGXS7tJJ2bme2hF6i2pbE6fdBL2THwUErTn3nfZok129wAEKl3ogWWCJj7EUGI8O90puxURVsxjxijEDQ== icinga@gravitontrading.com

EOF
echo "Verifying content of ROOT user authorized_keys"
echo
cat /root/.ssh/authorized_keys

cat /home/trading/.ssh/authorized_keys
if [ $? -ne 0 ] ; then
echo -e "${RED}/root/.ssh/authorized_keys file not present,${NC} please check and fix" >> temp.txt
fi

##################################
echo "CHECK 10"
echo
echo "checking the lib path for overclocking"
ls -ltr /usr/lib/tuned/pmqos-static.py
if [ $? -ne 0 ] ; then
echo -e "${RED}lib path for overclocking not present${NC} please check and fix" >> temp.txt
fi

#################################

echo "CHECK 11"
echo "checking timezone"
echo
echo `ls -l /etc/localtime` >> temp.txt
echo -e "${Green} check if above timezone is correct ${NC}" >> temp.txt

##################################

echo "CHECK 12"
echo
echo "Populating crontab for trading user"
`{ crontab -l -u trading 2>/dev/null; echo  '30 5 * * * (sudo date -s "$(curl -sD - google.com | grep ^Date: | cut -d'"'"' '"'"' -f3-6)Z" && sudo hwclock --systohc) > /tmp/time_sync.out'; } | uniq
- | crontab -u trading -`
echo "Verifying Crontab entry for trading user"
echo
crontab -l -u trading
if [ $? -ne 0 ] ; then
echo -e "${RED}crontab for trading user not present${NC} please check and fix" >> temp.txt
fi

#######################################
echo "CHECK 13"
echo
echo "checking pacman mirror list date"
echo
cat /etc/pacman.d/mirrorlist >> temp.txt
echo -e "${Green} check if above mirrorlist is correct ${NC}" >> temp.txt

#######################################
echo "CHECK 14"
echo
echo "Check RAID configuration"
lsblk >> temp.txt
echo -e "${Green} Verify above raid configurations ${NC}" >> temp.txt

echo
#######################################
echo "CHECK 15"
echo
echo "Output should be empty of python -c import numpy, pandas, dateutil, pytz"
python -c "import numpy, pandas, dateutil, pytz"
if [ $? -ne 0 ] ; then
echo -e "${RED}Issue with python import packages numpy, pandas, dateutil, pytz${NC} please check and fix" >> temp.txt
fi
########################################
echo "CHECK 16"
echo
echo "gcc version should match with archive archlinux version"
gcc --version | grep gcc >> temp.txt
echo -e "${Green} Verify GCC version above, should match with archive archlinux version ${NC}" >> temp.txt
echo
########################################
echo "CHECK 17"
echo
echo " Set Up /etc/sysctl.d/"
echo
cat << EOF > /etc/sysctl.d/10-hugepages.conf
vm.nr_hugepages=1024
EOF
echo
cat << EOF > /etc/sysctl.d/80-NSEMD.conf
net.core.netdev_max_backlog=50000
net.core.rmem_max=134217728
net.ipv4.tcp_mem=10240 87380 134217728
EOF

cat << EOF > /etc/sysctl.d/80-rp_filter.conf
net.ipv4.conf.default.rp_filter = 2
EOF

cat << EOF > /etc/sysctl.d/80-TAP.conf
net.ipv4.tcp_keepalive_intvl=2
net.ipv4.tcp_keepalive_time=20
net.ipv4.tcp_keepalive_probes=5
EOF

echo
echo "Verifying contents of file"
echo
echo "10-hugepages.conf"
echo
cat /etc/sysctl.d/10-hugepages.conf | grep vm.nr_hugepages=1024
if [ $? -ne 0 ] ; then
echo -e "${RED}hugepages not set properly${NC} please check and fix /etc/sysctl.d/10-hugepages.conf" >> temp.txt
fi

echo "80-NSEMD.conf"
echo
cat  /etc/sysctl.d/80-NSEMD.conf | grep -v net.core.netdev_max_backlog=50000 | grep -v net.core.rmem_max=134217728 | grep -v "net.ipv4.tcp_mem=10240 87380 134217728"
if [ $? -eq 0 ] ; then
echo -e "${RED}80-NSEMD.conf not set properly${NC} please check and fix /etc/sysctl.d/80-NSEMD.conf" >> temp.txt
fi

echo "80-TAP.conf"
echo
cat  /etc/sysctl.d/80-TAP.conf | grep -v net.ipv4.tcp_keepalive_intvl=2 | grep -v net.ipv4.tcp_keepalive_time=20 | grep -v net.ipv4.tcp_keepalive_probes=5
if [ $? -eq 0 ] ; then
echo -e "${RED}80-TAP.conf not set properly${NC} please check and fix /etc/sysctl.d/80-TAP.conf" >> temp.txt
fi
echo

echo "80-rp_filter.conf"
echo
cat /etc/sysctl.d/80-rp_filter.conf | grep "net.ipv4.conf.default.rp_filter = 2"
if [ $? -ne 0 ] ; then
echo -e "${RED}80-rp_filter.conf not set properly${NC} please check and fix /etc/sysctl.d/80-rp_filter.conf" >> temp.txt
fi

echo
###################################################
echo "CHECK 18"
echo "Bashrc setting for trading user"
sudo cp /root/.bashrc /home/trading/.bashrc
echo "Verifying content"
cat /home/trading/.bashrc
echo
#########################################################
echo "CHECK 19"
echo
echo "checking configured Clock Speed should be 3200"
echo `sudo dmidecode —type memory | grep 'Configured Clock Speed:'`
echo
#######################################################
echo "CHECK 20"
echo
echo "checking all installed packages"
packages=" python-pandas
    python-psutil
    python-pyinotify
    python-setproctitle
    python-tornado
    r
    rsync
    s3cmd
    socat
    cronie
    dbus-glib
    efibootmgr
    htop
    i7z
    linux
    linux-headers
    linux-lts
    linux-lts-headers
    tmux
    vim
    multitail
    netctl
    man
    nano
    gdb
    lsof
    mutt
    openssh
    perf
    pkgfile
    powerline
    python-configobj
    python-msgpack
git
rlwrap
jshon
apacman
bc
cronie
dbus-glib
efibootmgr
htop
i7z
linux
linux-headers
linux-lts
linux-lts-headers
tmux
vim
multitail
netctl
man
nano
gdb
lsof
mutt
openssh
perf
pkgfile
powerline
python-configobj
python-msgpack
python-pandas
python-psutil
python-pyinotify
python-setproctitle
python-tornado
python2-gobject2
r
rsync
s3cmd
socat
wget
python2
gcc-fortran
ttf-dejavu
tuned
tcpdump
dmidecode
lshw
gperftools
gentoo-bashrc
mprime
openbsd-netcat
lm_sensors
python2-linux-procfs
"
for i in $packages
do
pacman -Qi $i 1> /dev/null 2> /dev/null
if [ $? -ne 0 ]
then
yes | pacman -S $i
pacman -Qi $i
if [ $? -ne 0 ] ; then
echo -e "${RED}package not found for $i${NC}, please install package" >> temp.txt
fi
fi
done




cat temp.txt

