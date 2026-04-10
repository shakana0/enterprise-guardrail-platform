using Azure.Messaging.ServiceBus;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

// Add Service Bus client
builder.Services.AddSingleton(sp =>
{
    var connectionString = builder.Configuration["ServiceBusConnection"];
    return new ServiceBusClient(connectionString);
});

var app = builder.Build();

app.MapOpenApi();

app.MapScalarApiReference(options =>
{
    options.Title = "Enterprise Guardrail Platform API";
});

// Health check
app.MapGet("/health", () => Results.Ok(new { status = "healthy" }));

// Test endpoint
app.MapGet("/work", () => Results.Ok(new { message = "API workload running" }));

// Send message to queue
app.MapPost("/queue/send", async (ServiceBusClient client, MessageDto dto) =>
{
    var sender = client.CreateSender("demo-queue");
    await sender.SendMessageAsync(new ServiceBusMessage(dto.Message));
    return Results.Ok(new { sent = dto.Message });
});

app.Run();

record MessageDto(string Message);
