<script lang="ts">
    import { Button } from '$lib/components/ui/button';
	import { LogIn } from 'lucide-svelte';

</script>

<div class="flex max-w-full justify-end">
	<Button
		class="w-48 border-4 border-b-[#FBBD05] border-l-[#34A853] border-r-[#EA4336] border-t-[#4285F4]"
	>
		<LogIn class="mr-2" size="20" />
		Log In With Google
	</Button>
</div>
