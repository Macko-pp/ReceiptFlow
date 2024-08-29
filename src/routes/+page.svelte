<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Input } from '$lib/components/ui/input/index';
	import { Label } from '$lib/components/ui/label/index';
	import * as Alert from '$lib/components/ui/alert';

	import { Receipt } from 'lucide-svelte';

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

<div class="p-8 w-full grid gap-2 max-w-full">
	<form on:submit={mindeeSubmit} class="grid w-full max-w-full items-center gap-2">
		<Label for="my-file-input" class="text-4xl font-bold">Receipt Scanner</Label>
		<Input
			class="bg-slate-100 text-black"
			type="file"
			id="my-file-input"
			name="file"
			accept="image/*"
			required
			capture="environment"
			on:change={handleFileChange}
		/>
		<Button type="submit">Submit</Button>
	</form>

	<Alert.Root class="bg-slate-100">
		<Receipt />
		<Alert.Title class="text-xl font-bold">Receipt Summary</Alert.Title>
		<Alert.Description class="flex flex-col text-base">
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
		</Alert.Description>
	</Alert.Root>

	{#if imageUrl}
		<!-- Conditionally render the image if it exists -->
		<Alert.Root class="flex items-center justify-center max-w-full bg-slate-100">
			<img src="{imageUrl.toString()}" alt="Uploaded Receipt" class="max-h-[550px] rounded-lg" />
		</Alert.Root>
	{/if}
</div>

