<script lang="ts">
	import { signIn, signOut } from '@auth/sveltekit/client';
	import { page } from '$app/stores';

	console.log($page.data.session);

	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input/index';
	import { Label } from '$lib/components/ui/label/index';
	import * as Accordion from '$lib/components/ui/accordion';
	import * as Alert from '$lib/components/ui/alert';
	import * as Avatar from '$lib/components/ui/avatar';
	import * as DropdownMenu from '$lib/components/ui/dropdown-menu';

	import { Receipt, LogIn, LogOut, LogOutIcon } from 'lucide-svelte';

	let supplier_name: string;
	let total_amount: string;
	let date: string;
	let time: string;

	let receipt: any;
	let data: any;
	let myFile: any;
	let imageUrl: string | ArrayBuffer | null = null; // To hold the uploaded image URL

	const handleFileChange = (event: Event) => {
		const input = event.target as HTMLInputElement;
		if (input.files && input.files[0]) {
			myFile = input.files[0];
			const reader = new FileReader();
			reader.onload = () => {
				imageUrl = reader.result; // Set the image URL
			};
			reader.readAsDataURL(myFile); // Read the file as a data URL
		}
	};

	const mindeeSubmit = (evt: { preventDefault: () => void }) => {
		evt.preventDefault();
		if (!myFile) {
			return;
		}
		data = new FormData();
		data.append('document', myFile, myFile.name);

		let xhr = new XMLHttpRequest();

		xhr.addEventListener('readystatechange', function () {
			if (this.readyState === 4) {
				const response = JSON.parse(this.response);
				receipt = response.document.inference.prediction;

				supplier_name = receipt.supplier_name.value;
				total_amount = receipt.total_amount.value;
				date = receipt.date.value;
				time = receipt.time.value;

				console.log('Supplier Name: ', supplier_name);
				console.log('Total Amount: ', total_amount);
				console.log('Purchase Date: ', date);
				console.log('Purchase Time: ', time);
			}
		});

		xhr.open('POST', 'https://api.mindee.net/v1/products/mindee/expense_receipts/v5/predict');
		xhr.setRequestHeader('Authorization', 'Token f7e95d2d4b47684c6c553cf88a093d15');
		xhr.send(data);
	};
</script>

<div class="grid w-full max-w-full gap-2 p-8">
	<div class="flex max-w-full justify-end">
		{#if $page.data.session}
			<DropdownMenu.Root>
				<DropdownMenu.Trigger
					><Avatar.Root
						class="border-4 border-b-[#FBBD05] border-l-[#34A853] border-r-[#EA4336] border-t-[#4285F4]"
					>
						<Avatar.Image
							src={$page.data.session.user?.image}
							alt={$page.data.session.user?.name}
						/>
						<Avatar.Fallback>
							{$page.data.session.user?.name
								?.split(' ')
								.slice(0, 2)
								.map((word) => word.charAt(0).toUpperCase())
								.join('')}
						</Avatar.Fallback>
					</Avatar.Root></DropdownMenu.Trigger
				>
				<DropdownMenu.Content>
					<!-- <DropdownMenu.Label>My Account</DropdownMenu.Label>
					<DropdownMenu.Separator /> -->
					<DropdownMenu.Item on:click={() => signOut()} class="font-bold">
						<LogOutIcon class="mr-2" size="20"/>
						Log Out
					</DropdownMenu.Item>
				</DropdownMenu.Content>
			</DropdownMenu.Root>
			
		{:else}
			<Button
				on:click={() => signIn('google')}
				class="w-32 border-4 border-b-[#FBBD05] border-l-[#34A853] border-r-[#EA4336] border-t-[#4285F4]"
			>
				<LogIn class="mr-2" size="20" />
				Log In
			</Button>

		{/if}
	</div>

	<form on:submit={mindeeSubmit} class="grid w-full max-w-full items-center gap-2">
		<Label for="my-file-input" class="text-4xl font-bold"
			><Receipt class="mb-2 inline-block" size="32" />Receipt Scanner</Label
		>
		<Input
			class="light:bg-slate-100 dark:bg-slate-900"
			type="file"
			id="my-file-input"
			name="file"
			accept="image/*"
			required
			capture="environment"
			on:change={handleFileChange}
		/>
		<Button class="light:bg-slate-900 font-bold dark:bg-slate-100" type="submit">Submit</Button>
	</form>

	<!-- <Separator class="mb-2 mt-2 h-[3px]" /> -->

	<Alert.Root class="light:bg-slate-100 py-0 pl-0 dark:bg-slate-900">
		<Accordion.Root>
			<Accordion.Item value="item1">
				<Accordion.Trigger class="font-bold">Receipt Summary</Accordion.Trigger>
				<Accordion.Content class="flex flex-col">
					<div class="flex flex-row">
						<span class="mr-1">Supplier Name:</span>
						<span class="font-bold">{receipt ? supplier_name : ''}</span>
					</div>
					<div class="flex flex-row">
						<span class="mr-1">Total Amount:</span>
						<span class="font-bold">{receipt ? total_amount : ''}</span>
					</div>
					<div class="flex flex-row">
						<span class="mr-1">Purchase Date:</span>
						<span class="font-bold">{receipt ? date : ''}</span>
					</div>
					<div class="flex flex-row">
						<span class="mr-1">Purchase Time:</span>
						<span class="font-bold">{receipt ? time : ''}</span>
					</div>
				</Accordion.Content>
			</Accordion.Item>
		</Accordion.Root>
	</Alert.Root>

	{#if imageUrl}
		<!-- Conditionally render the image if it exists -->
		<Alert.Root
			class="light:bg-slate-100 flex max-w-full items-center justify-center dark:bg-slate-900"
		>
			<img src={imageUrl.toString()} alt="Uploaded Receipt" class="max-h-[550px] rounded-lg" />
		</Alert.Root>
	{/if}
</div>
