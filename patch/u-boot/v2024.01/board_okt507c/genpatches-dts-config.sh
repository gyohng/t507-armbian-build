#!/bin/bash

cat <<EOF >okt507c-uboot-config.patch.tmp
diff --git a/configs/okt507c_defconfig b/configs/okt507c_defconfig
new file mode 100644
index 0000000000..50079f4019
--- /dev/null
+++ b/configs/okt507c_defconfig
@@ -0,0 +1,41 @@
EOF

sed 's/^/+/g' okt507c_defconfig >>okt507c-uboot-config.patch.tmp
rediff okt507c-uboot-config.patch.tmp >okt507c-uboot-config.patch
rm -rf okt507c-uboot-config.patch.tmp

cat <<EOF >okt507c-uboot-dts.patch.tmp
diff --git a/arch/arm/dts/sun50i-t507-okt507c.dts b/arch/arm/dts/sun50i-t507-okt507c.dts
new file mode 100644
index 0000000000..3ec8831e05
--- /dev/null
+++ b/arch/arm/dts/sun50i-t507-okt507c.dts
@@ -0,0 +1,333 @@
EOF

sed 's/^/+/g' sun50i-t507-okt507c.dts >>okt507c-uboot-dts.patch.tmp
rediff okt507c-uboot-dts.patch.tmp >okt507c-uboot-dts.patch
rm -rf okt507c-uboot-dts.patch.tmp
