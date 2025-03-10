{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromSourcehut,
  pytestCheckHook,
  pythonOlder,
  sqlparse,
  wrapt,
}:

buildPythonPackage rec {
  pname = "embrace";
  version = "4.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~olly";
    repo = "embrace-sql";
    rev = "v${version}-release";
    hash = "sha256-B/xW5EfaQWW603fjKYcf+RHQJVZrnFoqVnIl6xSwS0E=";
  };

  propagatedBuildInputs = [
    sqlparse
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "embrace" ];

  # Some test for hot-reload fails on Darwin, but the rest of the library
  # should remain usable. (https://todo.sr.ht/~olly/embrace-sql/4)
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Embrace SQL keeps your SQL queries in SQL files";
    homepage = "https://pypi.org/project/embrace/";
    license = licenses.asl20;
    maintainers = with maintainers; [ euxane ];
  };
}
