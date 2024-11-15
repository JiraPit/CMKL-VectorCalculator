docker login -u _json_key --password-stdin https://asia-southeast1-docker.pkg.dev <keys/vector-calculator-server-deployer.json
docker build . -t asia-southeast1-docker.pkg.dev/cmkl-vectorcalculator/vector-calculator-server/vector-calculator-server
docker push asia-southeast1-docker.pkg.dev/cmkl-vectorcalculator/vector-calculator-server/vector-calculator-server
