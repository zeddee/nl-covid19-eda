DATENOW=$(date +%Y-%m-%d)
YEST=$(date --date="yesterday" +%Y-%m-%d)
if [[ $OSTYPE == *"darwin"* ]]; then
  YEST=$(date -v-1d +%Y-%m-%d) # macos
fi

function replacedate () {
    if [[ $OSTYPE == *"darwin"* ]]; then
        sed -i .bak "13,54s/$YEST/$DATENOW/g" nl-covid-eda.ipynb
    else
        sed --in-place="bak" "13,54s/$YEST/$DATENOW/g" nl-covid-eda.ipynb
    fi
}

FILEONE="_data/COVID-19_aantallen_gemeente_cumulatief-$DATENOW.csv"
# FILETWO="_data/COVID-19_casus_landelijk$DATENOW.csv"
if $(! test -f "$FILEONE"); then curl https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_cumulatief.csv -o $FILEONE; fi
# if $(! test -f "$FILETWO"); then curl https://data.rivm.nl/covid-19/COVID-19_casus_landelijk.csv -o $FILETWO; fi
echo replacing $YEST with $DATENOW && replacedate
python3 -m jupyter nbconvert --to notebook --inplace --execute nl-covid-eda.ipynb # run notebook
