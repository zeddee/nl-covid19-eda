DATENOW=$(date +%Y-%m-%d)

# Set YEST to use a regex pattern matching YYYY-MM-DD instead
YEST="\d{4}-\d{2}-\d{2}"

#if [[ $OSTYPE == *"darwin"* ]]; then
#  YEST=$(date -v-1d +%Y-%m-%d) # macos
#elif [[ $OSTYPE == *"linux"* ]]; then
#  YEST=$(date --date="yesterday" +%Y-%m-%d)
#fi

function replacedate () {
    if [[ $OSTYPE == *"darwin"* ]]; then
        sed -E -i .bak "13,70s/\d{4}-\d{2}-\d{2}/$DATENOW/g" nl-covid-eda.ipynb
    else
        sed -E --in-place="bak" "13,70s/\d{4}-\d{2}-\d{2}/$DATENOW/g" nl-covid-eda.ipynb
    fi
}

FILEONE="_data/COVID-19_aantallen_gemeente_cumulatief-$DATENOW.csv"
# FILETWO="_data/COVID-19_casus_landelijk$DATENOW.csv"
if $(! test -f "$FILEONE"); then curl https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_cumulatief.csv -o $FILEONE; fi
# if $(! test -f "$FILETWO"); then curl https://data.rivm.nl/covid-19/COVID-19_casus_landelijk.csv -o $FILETWO; fi
echo replacing $YEST with $DATENOW && replacedate
python3 -m jupyter nbconvert --to notebook --inplace --execute nl-covid-eda.ipynb # run notebook
