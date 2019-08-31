<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="assets/js/addonsinfo.<?=$time?>.js"></script>
<script>
	$.post( 'commands.php', { bash: [
		  "sed -i '/runonce.php/ d' /srv/http/indexbody.php"
		, 'rm /srv/http/runonce.php'
	] } );
	info( {
		  icon    : 'rune'
		, title   : 'RuneAudio'
		, message : 'Welcome to RuneAudio'
				   +'<br><br>Show <wh>Web user interface</wh> connection for remote devices?'
		, cancellabel  : 'No'
		, cancel  : function() {
			location.reload();
		}
		, ok      : function() {
			location.href='indexsettings.php?p=network';
		}
	} )
</script>
</body>
</html>
<?php exit();?>
