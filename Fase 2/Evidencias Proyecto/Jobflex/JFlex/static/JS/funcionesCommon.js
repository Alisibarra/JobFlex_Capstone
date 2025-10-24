
function showLoader() {
	const loader = $('#page-loader');
	loader.removeClass('hidden animate-fade-out');
	loader.addClass('animate-fade-in');
}

function hideLoader() {
	const loader = $('#page-loader');
	loader.removeClass('animate-fade-in');
	loader.addClass('animate-fade-out');
	
	// Hide completely after animation ends
	loader.on('animationend', () => {
		if (loader.hasClass('animate-fade-out')) {
			loader.addClass('hidden');
		}
	});
}

function loadModal(urlOrName, params = [], closeOnBackdrop = false, modalId = "globalModal") {
	let url = urlOrName;

	// Resolve Django URL if django-js-reverse is available
	if (typeof Urls !== "undefined" && Urls[urlOrName]) {
		url = Urls[urlOrName](...params);
	}

	const $modal = $("#" + modalId);
	const $backdrop = $modal.find(".modal-backdrop");
	const $content = $modal.find(".modal-content");
	const $body = $modal.find(".modal-body");

	// Clear previous content or show loading state
	$body.html("<div class='text-gray-500 text-center py-4'>Loading...</div>");

	// Fetch partial via AJAX
	$.ajax({
		url: url,
		method: "GET",
		dataType: "html",
		beforeSend: showLoader(),
		success: function (response) {
			$content.html(response);

			// Show modal (unhide first)
			$modal.removeClass("hidden");

			// Animate fade in
			$backdrop.removeClass("animate-fade-out").addClass("animate-fade-in");
			$content.removeClass("animate-fade-out").addClass("animate-fade-in");

			// Control backdrop close
			$modal.data("closeOnBackdrop", closeOnBackdrop);
			hideLoader();
		},
		error: function () {
			hideLoader();
			$body.html("<p class='text-red-500 text-center py-4'>Error loading modal content.</p>");
			$modal.removeClass("hidden");
		}
	});
}

// Close modal function
function closeModal($modal) {
		const $backdrop = $modal.find(".modal-backdrop");
		const $content = $modal.find(".modal-content");

		// Animate fade out
		$backdrop.removeClass("animate-fade-in");
		$content.removeClass("animate-fade-in");

		$backdrop.addClass("animate-fade-out");
		$content.addClass("animate-fade-out");
		
		// Wait for transition then hide completely
		setTimeout(() => {
			$modal.addClass("hidden");
			$modal.find(".modal-body").html("");
		}, 200); // matches Tailwind default transition duration
}

// Close button
$(document).on("click", ".close-modal", function() {
		closeModal($(this).closest("[id$='Modal']"));
});

// Backdrop click (optional)
$(document).on("click", "[id$='Modal']", function(e) {
		if ($(e.target).is(this)) {
				const closeOnBackdrop = $(this).data("closeOnBackdrop");
				if (closeOnBackdrop) {
						closeModal($(this));
				}
		}
});