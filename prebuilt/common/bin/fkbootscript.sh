#!/system/bin/sh
# 15-Apr-2013

# custom busybox installation shortcut
bb=/system/xbin/busybox;

# disable sysctl.conf to prevent ROM interference with tunables
# backup and replace PowerHAL with custom build to allow OC/UC to survive screen off
# create and set permissions for /system/etc/init.d if it doesn't already exist
$bb mount -o rw,remount /system;
$bb [ -e /system/etc/sysctl.conf ] && $bb mv /system/etc/sysctl.conf /system/etc/sysctl.conf.fkbak;
$bb [ -e /system/lib/hw/power.tuna.so.fkbak ] || $bb cp /system/lib/hw/power.tuna.so /system/lib/hw/power.tuna.so.fkbak;
$bb cp /sbin/power.tuna.so /system/lib/hw/;
$bb chmod 644 /system/lib/hw/power.tuna.so;
if [ ! -e /system/etc/init.d ]; then
  $bb mkdir /system/etc/init.d
  $bb chown -R root.root /system/etc/init.d;
  $bb chmod -R 755 /system/etc/init.d;
fi;
$bb mount -o ro,remount /system;

# disable debugging
echo "0" > /sys/module/wakelock/parameters/debug_mask;
echo "0" > /sys/module/userwakelock/parameters/debug_mask;
echo "0" > /sys/module/earlysuspend/parameters/debug_mask;
echo "0" > /sys/module/alarm/parameters/debug_mask;
echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
echo "0" > /sys/module/binder/parameters/debug_mask;

# general queue tweaks
for i in /sys/block/*/queue; do
  echo 512 > $i/nr_requests;
  echo 512 > $i/read_ahead_kb;
  echo 2 > $i/rq_affinity;
  echo 0 > $i/nomerges;
  echo 0 > $i/add_random;
  echo 0 > $i/iostats;
  echo 0 > $i/rotational;
done;

# set tweaks as scheduler defaults
# but only if /system/etc/init.d/950iosettings isn't present
if [ ! -e /system/etc/init.d/950iosettings ]; then
  scheduler=reset;
  while sleep 1; do
    current=`$bb cut -d\[ -f2 /sys/block/mmcblk0/queue/scheduler | $bb cut -d\] -f1`;
    if [ $scheduler != $current ]; then
      scheduler=$current;
      if [ $scheduler == "deadline" ]; then
        # deadline tweaks
        echo 3500 > /sys/block/mmcblk0/queue/iosched/read_expire;
        echo 750 > /sys/block/mmcblk0/queue/iosched/write_expire;
        echo 1 > /sys/block/mmcblk0/queue/iosched/writes_starved;
        echo 1 > /sys/block/mmcblk0/queue/iosched/front_merges;
        echo 1 > /sys/block/mmcblk0/queue/iosched/fifo_batch;
      elif [ $scheduler == "row" ]; then
        # row tweaks
        echo 100 > /sys/block/mmcblk0/queue/iosched/hp_read_quantum;
        echo 75 > /sys/block/mmcblk0/queue/iosched/rp_read_quantum;
        echo 5 > /sys/block/mmcblk0/queue/iosched/hp_swrite_quantum;
        echo 4 > /sys/block/mmcblk0/queue/iosched/rp_swrite_quantum;
        echo 4 > /sys/block/mmcblk0/queue/iosched/rp_write_quantum;
        echo 3 > /sys/block/mmcblk0/queue/iosched/lp_read_quantum;
        echo 12 > /sys/block/mmcblk0/queue/iosched/lp_swrite_quantum; 
        echo 10 > /sys/block/mmcblk0/queue/iosched/read_idle;
        echo 25 > /sys/block/mmcblk0/queue/iosched/read_idle_freq;
        ## N4 and N10 have a new version of row with corrected entry for lsq and renamed ri and rif
        $bb [ `cat /sys/block/mmcblk0/queue/iosched/lp_swrite_quantum` != "2" ] && echo 2 > /sys/block/mmcblk0/queue/iosched/lp_swrite_quantum;
        echo 10 > /sys/block/mmcblk0/queue/iosched/rd_idle_data;
        echo 25 > /sys/block/mmcblk0/queue/iosched/rd_idle_data_freq;
      elif [ $scheduler == "cfq" ]; then
        # cfq tweaks
        echo 8 > /sys/block/mmcblk0/queue/iosched/quantum;
        echo 80 > /sys/block/mmcblk0/queue/iosched/fifo_expire_sync;
        echo 330 > /sys/block/mmcblk0/queue/iosched/fifo_expire_async;
        echo 12582912 > /sys/block/mmcblk0/queue/iosched/back_seek_max;
        echo 1 > /sys/block/mmcblk0/queue/iosched/back_seek_penalty;
        echo 60 > /sys/block/mmcblk0/queue/iosched/slice_sync;
        echo 50 > /sys/block/mmcblk0/queue/iosched/slice_async;
        echo 2 > /sys/block/mmcblk0/queue/iosched/slice_async_rq;
        echo 0 > /sys/block/mmcblk0/queue/iosched/slice_idle;
        echo 7 > /sys/block/mmcblk0/queue/iosched/group_idle;
        echo 1 > /sys/block/mmcblk0/queue/iosched/low_latency;
        ## N4 and N10 cfq adds tl, which was hardcoded previously
        echo 300 > /sys/block/mmcblk0/queue/iosched/target_latency;
      fi;
    fi;
  # loop forever independently
  done&
fi;

# lmk whitelist for common launchers
list="com.android.launcher org.adw.launcher org.adwfreak.launcher com.anddoes.launcher com.gau.go.launcherex com.mobint.hololauncher com.mobint.hololauncher.hd com.teslacoilsw.launcher com.cyanogenmod.trebuchet org.zeam";
sleep 60;
for class in $list; do
  pid=`pidof $class`;
  if [ $pid != "" ]; then
    echo "-17" > /proc/$pid/oom_adj;
    chmod 100 /proc/$pid/oom_adj;
  fi;
done;

