<?php

declare(strict_types=1);

namespace App\Infrastructure\User;

use App\Domain\User\Port\UserApiClientInterface;
use Symfony\Contracts\HttpClient\HttpClientInterface;
use Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface;

class PhoenixApiClient implements UserApiClientInterface
{
    private HttpClientInterface $client;
    private string $url;
    private string $token;

    public function __construct(
        HttpClientInterface $client,
        string $url,
        string $token
    ) {
        $this->client = $client;
        $this->url = rtrim($url, '/');
        $this->token = $token;
    }

    public function list(array $filters = []): array
    {
        $query = http_build_query($filters);
        $response = $this->client->request('GET', $this->url.'/users'.($query ? "?$query" : ''));

        return $response->toArray();
    }

    public function get(string $id): ?array
    {
        try {
            $response = $this->client->request('GET', $this->url.'/users/'.$id);

            return $response->toArray();
        } catch (TransportExceptionInterface $e) {
            return null;
        }
    }

    public function create(array $data): array
    {
        $response = $this->client->request('POST', $this->url.'/users', [
            'json' => $data,
        ]);

        return $response->toArray();
    }

    public function update(string $id, array $data): array
    {
        $response = $this->client->request('PUT', $this->url.'/users/'.$id, [
            'json' => $data,
        ]);

        return $response->toArray();
    }

    public function delete(string $id): bool
    {
        $response = $this->client->request('DELETE', $this->url.'/users/'.$id);

        return $response->getStatusCode() === 204;
    }

    public function import(): array
    {
        $response = $this->client->request('POST', $this->url.'/import', [
            'headers' => [
                'x-import-token' => $this->token
            ]
        ]);

        return $response->toArray();
    }
}
