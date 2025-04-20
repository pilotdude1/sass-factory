<script>
	import { onMount } from 'svelte';

	let deferredPrompt;
	let showInstallButton = false;

	onMount(() => {
		window.addEventListener('beforeinstallprompt', (e) => {
			// Prevent Chrome 67 and earlier from automatically showing the prompt
			e.preventDefault();
			// Stash the event so it can be triggered later
			deferredPrompt = e;
			// Show the install button
			showInstallButton = true;
		});

		window.addEventListener('appinstalled', () => {
			// Clear the deferredPrompt
			deferredPrompt = null;
			// Hide the install button
			showInstallButton = false;
			console.log('PWA was installed');
		});
	});

	function installPWA() {
		if (!deferredPrompt) return;

		// Show the install prompt
		deferredPrompt.prompt();

		// Wait for the user to respond to the prompt
		deferredPrompt.userChoice.then((choiceResult) => {
			if (choiceResult.outcome === 'accepted') {
				console.log('User accepted the install prompt');
			} else {
				console.log('User dismissed the install prompt');
			}

			// Clear the deferredPrompt
			deferredPrompt = null;
			// Hide the install button
			showInstallButton = false;
		});
	}
</script>

{#if showInstallButton}
	<div
		class="fixed bottom-5 left-1/2 transform -translate-x-1/2 z-50 bg-blue-500 text-white px-5 py-3 rounded-lg shadow-lg"
	>
		<button
			on:click={installPWA}
			class="border-2 border-white text-white py-2 px-4 rounded font-bold transition-colors hover:bg-white hover:text-blue-500"
		>
			Install App
		</button>
	</div>
{/if}
