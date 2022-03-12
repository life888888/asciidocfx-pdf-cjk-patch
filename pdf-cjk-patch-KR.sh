export BASE=`pwd`
export CJK_FONT_DIR=$BASE/conf/fonts/KaiGenGothic
export DOCBOOK_CONFIG_DIR=$BASE/conf/docbook-config

# Check if under AsciidocFX root folder
if [ -f "AsciidocFX.vmoptions" ]
then
   echo "can continue to the next step!"
else
   echo "Is not under AsciidocFX root folder , please put me under root folder!"
   exit
fi

# create CJK_FONT_DIR
mkdir -p $CJK_FONT_DIR

# download CJK Fonts
wget -P $CJK_FONT_DIR https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicKR-Regular.ttf
wget -P $CJK_FONT_DIR https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicKR-Bold.ttf
wget -P $CJK_FONT_DIR https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicKR-Regular-Italic.ttf
wget -P $CJK_FONT_DIR https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases/download/v0.1.0-fonts/KaiGenGothicKR-Bold-Italic.ttf

# md5 checksum
cp pdf-cjk-patch/KR/KaiGenGothicKR.fonts.md5 $CJK_FONT_DIR/
cd $CJK_FONT_DIR/
md5sum -c KaiGenGothicKR.fonts.md5


if [ $? -ne 0 ]
then
    cd $BASE
    echo "The downloaded font is incorrect, please delete the font file and execute pdf-cjk-patch-KR.sh again."
    exit
fi


cd $BASE

# copy font xml
cp pdf-cjk-patch/KR/KaiGenGothicKR-Regular.xml $CJK_FONT_DIR/
cp pdf-cjk-patch/KR/KaiGenGothicKR-Bold.xml $CJK_FONT_DIR/
cp pdf-cjk-patch/KR/KaiGenGothicKR-Regular-Italic.xml $CJK_FONT_DIR/
cp pdf-cjk-patch/KR/KaiGenGothicKR-Bold-Italic.xml $CJK_FONT_DIR/

# backup docbook-config
cd $DOCBOOK_CONFIG_DIR/
cp fop.xconf.xml fop.xconf.xml.org
cp fo-pdf.xsl fo-pdf.xsl.org
cd $BASE

# patch docbook-config
cp pdf-cjk-patch/KR/asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch $DOCBOOK_CONFIG_DIR/
cp pdf-cjk-patch/KR/asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch $DOCBOOK_CONFIG_DIR/

cd $DOCBOOK_CONFIG_DIR/
patch -p0 < asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch
if [ $? -ne 0 ]
then
  touch asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch.FAIL
fi

patch -p0 < asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch
if [ $? -ne 0 ]
then
  touch asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch.FAIL
fi

cd $BASE

if [ -f "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch.FAIL" ]
then
    echo "patch is fail, you can try modify $DOCBOOK_CONFIG_DIR/fop.xconf.xml by yourself."
    echo "you can reference this file"
    echo "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch"
fi

if [ -f "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch.FAIL" ]
then
    echo "patch is fail, you can try modify $DOCBOOK_CONFIG_DIR/fo-pdf.xsl by yourself."
    echo "you can reference this file"
    echo "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch"
fi

if [ -f "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch.FAIL" ]
then
   exit
fi

if [ -f "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch.FAIL" ]
then
   exit
fi


echo "AsciidoxFX PDF CJK Patch For KR is finish."

# Open Example Asciidoc to test
echo "You can use AsciidocFX to open your korea asciidoc to test"
echo "and PDF -> Save"
echo "then check the pdf"
# sorry , I am not prepare korea asciidoc to test.
# echo "You can use AsciidocFX to open $BASE/pdf-cjk-patch/testdoc/PDF-CJK-TEST_KR.adoc"
# echo "and PDF -> Save"
# echo "then check $BASE/pdf-cjk-patch/testdoc/PDF-CJK-TEST_KR.pdf"



# delete patch file
if [ -f "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch" ]
then
  rm $DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fop.xconf.xml_KR.patch
fi

if [ -f "$DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch" ]
then
  rm $DOCBOOK_CONFIG_DIR/asciidocfx-1.7.4-pdf-cjk_fo-pdf.xsl_KR.patch
fi


# delete md5
if [ -f "$CJK_FONT_DIR/KaiGenGothicKR.fonts.md5" ]
then
   rm $CJK_FONT_DIR/KaiGenGothicKR.fonts.md5
fi

