<script>
	import PWAInstallPrompt from '$lib/components/PWAInstallPrompt.svelte';
	import '../app.css';
</script>

<main>
	<slot />
</main>

<PWAInstallPrompt />
